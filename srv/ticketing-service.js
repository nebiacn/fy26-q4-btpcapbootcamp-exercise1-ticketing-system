const cds = require('@sap/cds');

class TicketingService extends cds.ApplicationService {
    init() {
        const { Tickets, Comments, Agents } = this.entities;

        // Validate if Subject and Category are provided when creating a new ticket
        this.before('CREATE', 'Tickets', (req) => {
            const subject = req.data.subject;
            const category = req.data.category_name;

            if (!subject) {
                req.error(400, 'Subject is required when creating a new ticket.', subject);
            }

            if (!category) {
                req.error(400, 'Category is required when creating a new ticket.', category);
            }         
        });

            // ---- Structured error: block updates that try to "re-close" a closed ticket ----
        this.before('UPDATE', 'Tickets', async (req) => {
        // TODO: only if req.data.status === 'CLOSED' —
        //   1. look up the ticket's *current* status with
        //      SELECT.one.from(Tickets, req.data.ID).columns('status')
        //   2. if it's already 'CLOSED', reject the request using a
        //      structured error object: req.error({ code, message, target })
        //      instead of the plain req.error(400, message, target) form.
        });        

        // ---- Custom action: closeTicket ----
        // Requires a resolution note, sets status to CLOSED, and logs the resolution as a Comment.
        this.on('closeTicket', 'Tickets', async (req) => {
        const { ID } = req.params[0];
        const { resolution } = req.data;

        debugger;

        // TODO 1: reject with 400 if `resolution` is missing.
        if (!resolution) {
            req.error(400, 'Resolution is required to close the ticket.', resolution);
            return;
        }
        // TODO 2: look up the ticket (SELECT.one.from(Tickets, ID).columns('status'));
        //         reject with 404 if it doesn't exist.
        if (ID) {
            const ticket = await SELECT.one.from(Tickets, ID).columns('status');
            if (!ticket) {
                req.error(404, 'Ticket not found.', ID);
            }
            else {
                // TODO 3: reject with a structured error (code: 'ALREADY_CLOSED') if the
                //         ticket's status is already 'CLOSED'.

                if (ticket.status === 'CLOSED') {
                    req.error({ code: 'ALREADY_CLOSED', message: 'Ticket is already closed.', target: ID });
                }
                else {
                    // TODO 4: UPDATE(Tickets, ID) to set status to 'CLOSED'.
                    await UPDATE(Tickets)
                        .set({ status: 'CLOSED' })
                        .where({ ID });

                    // TODO 5: INSERT.into(Comments) a new comment on this ticket recording
                    // the resolution text (e.g. `Ticket closed: ${resolution}`).            

                    const commentText = `Ticket closed: ${resolution}`;

                    await INSERT.into(Comments).entries({
                        ticket_ID: ID,
                        text: commentText
                    });

                    // TODO 6: return the updated ticket — SELECT.one.from(Tickets, ID).
                    const updatedTicket = await SELECT.one.from(Tickets, ID);
                    if (updatedTicket) {
                        return updatedTicket;
                    }
                }
            }
        }                        
        });

        return super.init();
    }    
}

module.exports = TicketingService;