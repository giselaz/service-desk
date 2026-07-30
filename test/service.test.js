const cds = require('@sap/cds');
const serviceUrl = '/odata/v4/service-desk';
const {GET, POST} = cds.test(__dirname + '/..');

describe('ServiceDeskService', () => {

  it('reads all Operations', async () => {
    const { data } = await GET(`${serviceUrl}/Operations`, { auth: { username: 'admin', password: '' } });
    expect(Array.isArray(data.value)).toBe(true);         
  });

  it('returns only requesters Operation', async () => {
    const { data } = await GET(`${serviceUrl}/Operations`, { auth: { username: 'erin', password: '' } });
    expect(data.value.length).toBe(2);
  });
    $operationId = 'e36977b4-8ef2-46ba-865a-35a125a91b5b';
    it(`creates a Comment on ${$operationId} Operation`, async() => {
        const { data } = await POST(`${serviceUrl}/Operations(ID=${$operationId},IsActiveEntity=true)/ServiceDeskService.addComment`, 
          { description: 'Test comment' }, 
          { auth: { username: 'erin', password: '' } });
          expect(data.description === 'Test comment').toBe(true);
        })
    it('blocks unauthorized requester from accessing other Operations', async () => {
        await expect(
            GET(`${serviceUrl}/Operations(ID=0c2cea12-7764-4c7f-94d9-9bcc16ebd366,IsActiveEntity=true)`,
                { auth: { username: 'erin', password: '' } })
          ).rejects.toThrow(/404/);
      });
});