using { ticketing.system as db } from '../db/schema';

service TicketingService {
    entity Categories as projection on db.Categories;
    entity Agents as projection on db.Agents;
    @odata.draft.enabled
    entity Tickets as projection on db.Tickets actions {
        action closeTicket(resolution: String) returns Tickets;
        action reassignTicket(agentID : UUID) returns Tickets;
    };

    annotate Tickets with actions {
        closeTicket @(
            Common.SideEffects : {
                    $Type : 'Common.SideEffectsType',
                    TargetEntities : [status, comments],
                },
        )
    };

    entity Comments as projection on db.Comments;
    entity Priorities as projection on db.Priorities;
    entity Statuses as projection on db.Statuses;

    function getTicketCount(status: db.TicketStatus) returns Integer;
}