using { ticketing.system as db } from '../db/schema';

service TicketingService {
    entity Categories as projection on db.Categories;
    entity Agents as projection on db.Agents;
    @odata.draft.enabled
    entity Tickets as projection on db.Tickets { 
        ID,
        ticketNumber,
        subject,
        description,
        status,
        case when status.name = 'OPEN' then '0'
             when status.name = 'IN_PROGRESS' then '5'
             when status.name = 'RESOLVED' then '3'
             when status.name = 'CLOSED' then '1'
             else '0' end as status_criticality : Integer,
        priority,
        case when priority.name = 'LOW' then '3'
             when priority.name = 'MEDIUM' then '2'
             when priority.name = 'HIGH' then '1'
             when priority.name = 'URGENT' then '1'
             else '0' end as priority_criticality : Integer,
        category,
        agent,
        comments
    } actions {
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