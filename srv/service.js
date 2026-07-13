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
            ID: cds.utils.uuid(),               // generate the key up front
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

    
}