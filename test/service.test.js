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
    $operationId = 'd0000000-0000-0000-0000-000000000001';
    it(`creates a Comment on ${$operationId} Operation`, async() => {
        const { data } = await POST(`${serviceUrl}/Operations(ID=${$operationId},IsActiveEntity=true)/ServiceDeskService.addComment`, 
          { description: 'Test comment' }, 
          { auth: { username: 'erin', password: '' } });
          expect(data.description === 'Test comment').toBe(true);
        })
    it('blocks unauthorized requester from accessing other Operations', async () => {
        await expect(
            GET(`${serviceUrl}/Operations(ID=d0000000-0000-0000-0000-000000000003,IsActiveEntity=true)`,
                { auth: { username: 'erin', password: '' } })
          ).rejects.toThrow(/404/);
      });
});