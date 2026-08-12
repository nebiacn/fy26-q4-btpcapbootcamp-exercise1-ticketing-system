sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ticketingsystem/ticketingsystem/test/integration/pages/TicketsList.gen",
	"ticketingsystem/ticketingsystem/test/integration/pages/TicketsObjectPage.gen"
], function (JourneyRunner, TicketsListGenerated, TicketsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ticketingsystem/ticketingsystem') + '/test/flp.html#app-preview',
        pages: {
			onTheTicketsListGenerated: TicketsListGenerated,
			onTheTicketsObjectPageGenerated: TicketsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

