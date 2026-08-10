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
            const ticket = await SELECT.one.from(Tickets, req.data.ID).columns('status');            
        //   2. if it's already 'CLOSED', reject the request using a
        //      structured error object: req.error({ code, message, target })
        //      instead of the plain req.error(400, message, target) form.
            if (req.data.status === 'CLOSED' && ticket.status === 'CLOSED') {
                req.error({ code: 'ALREADY_CLOSED', message: 'Ticket is already closed.', target: req.data.ID });
            }
        });         

        // ---- Custom action: closeTicket ----
        // Requires a resolution note, sets status to CLOSED, and logs the resolution as a Comment.
        this.on('closeTicket', 'Tickets', async (req) => {
        const { ID } = req.params[0];
        const { resolution } = req.data;

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

        // ---- Custom action: reassignTicket ----
        // Moves a ticket to a different agent; validates the agent actually exists.
        this.on('reassignTicket', 'Tickets', async (req) => {    
        const { ID } = req.params[0];
        const { agentID } = req.data;

        // TODO 1: reject with 400 if `agentID` is missing.
        if (!agentID) {
            req.error(400, 'Agent ID is required to reassign the ticket.', agentID);
            return;
        }
        // TODO 2: look up the agent (SELECT.one.from(Agents, agentID)); reject
        //         with 404 if it doesn't exist.
        const agent = await SELECT.one.from(Agents, agentID);
        if (!agent) {
            req.error(404, 'Agent not found.', agentID);
            return;
        }
        // TODO 3: UPDATE(Tickets, ID) to set agent_ID to the new agentID.
        await UPDATE(Tickets)
            .set({ agent_ID: agentID })
            .where({ ID });
        // TODO 4: return the updated ticket — SELECT.one.from(Tickets, ID).
        const updatedTicket = await SELECT.one.from(Tickets, ID);
        if (updatedTicket) {
            return updatedTicket;
        }
        });

        // ---- Custom function: getTicketCount ----
        // Read-only: counts tickets, optionally filtered by status.
        this.on('getTicketCount', async (req) => {
        // TODO: read req.data.status (it may be undefined). SELECT tickets from
        // Tickets, filtering by status only if one was passed, and return the
        // *count* of matching rows (not the rows themselves).
        const { status } = req.data;
        if (status) {
            const ticket = await SELECT.from(Tickets).where({ status: status });
            const count = ticket.length;
            return { count };
        } else {
            const tickets = await SELECT.from(Tickets);
            const count = tickets.length;
            return { count };
        }
        });

        // ---- after CREATE: log new tickets (stand-in for a real notification) ----
        // (worked example — no change needed)
        this.after('CREATE', 'Tickets', (ticket) => {
        console.log(`[TicketService] Ticket created: ${ticket.ticketNumber ?? ticket.ID}`);
        });        

        return super.init();
    }    
}

module.exports = TicketingService;