const cds = require('@sap/cds');

class TicketingService extends cds.ApplicationService {
    init() {
        const { Tickets, Comments, Agents } = this.entities;
    

        return super.init();
    }    
}