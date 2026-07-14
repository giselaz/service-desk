const { c } = require("@sap/cds/lib/utils/tar-lib");
module.exports = (srv) => {
    srv.before('CREATE','Operations',(req)=>{
        const operation = req.data;
        operation.status_code = "NEW"; 

    })
    srv.on('addComment','Operations',async(req)=> {
        const {Comments} = srv.entities;
        const operationId = req.params[0].ID;
        const {description} = req.data;
        
        const operationEntity = await SELECT.one.from(srv.entities.Operations).where({ID:operationId});
        if(!operationEntity){
            req.reject(404,`Operation not found`);
        }
        const comment = {
            ID: cds.utils.uuid(),    
            description,
            operation_ID: operationId,
        };
        await INSERT.into(Comments).entries(comment);
        if(operationEntity && (operationEntity.status_code === "STAND_BY" || operationEntity.status_code === "CLOSED")){
            await UPDATE(srv.entities.Operations).set({status_code:"USER_RESPONDED"}).where({ID:operationId});
        }
        return comment;
    })

    srv.on('READ', 'Configuration', (req) => {
    const isAgent = req.user.is('agent') || req.user.is('admin');
      req.reply({  isAgent:isAgent, isRequester: !isAgent });
    });
   

  srv.after(['CREATE', 'UPDATE'], 'Operations', async (data, req) => {
        const ticketData = data;
        if (!ticketData || !ticketData.company_ID) return;

        const tickets = await SELECT.from('Operation')
            .columns('ID').where({ company_ID: ticketData.company_ID });
        const ids = tickets.map(t => t.ID);

        let spent = 0;  
        if (ids.length) {
            const logs = await SELECT.from('Worklogs')
            .columns('durationInHours').where({ operation_ID: { in: ids } });
            spent = logs.reduce((s, w) => s + (Number(w.durationInHours) || 0) * 60, 0); 
        }

        const company = await SELECT.one.from('Companies')
            .columns('timeToSpend').where({ ID: ticketData.company_ID });
        const remaining = (company?.timeToSpend || 0) - spent;   

        await UPDATE('Companies')
            .set({ remainingTime: remaining })
            .where({ ID: ticketData.company_ID });
    });
    srv.after('READ', 'Operations', async (operations, req) => {
        const rows = [operations].flat().filter(Boolean);  
        if (rows.length !== 1) return;
        const operation = rows[0];
        if (!operation.company_ID) { operation.companyRemainingTime = null; return; }
            const company = await SELECT.one.from('Companies')
            .columns('remainingTime').where({ ID: operation.company_ID });
            operation.companyRemainingTime = company ? formatMinutes(company.remainingTime) : null;
    });
    function formatMinutes(min) {
        if (min == null) return null;
        const sign = min < 0 ? '-' : '';
        const abs = Math.abs(min);
        return `${sign}${Math.floor(abs / 60)}h ${abs % 60}m`;
    }
    
}