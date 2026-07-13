sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/tickets/servicedesk/test/integration/pages/OperationsList.gen",
	"com/tickets/servicedesk/test/integration/pages/OperationsObjectPage.gen"
], function (JourneyRunner, OperationsListGenerated, OperationsObjectPageGenerated) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/tickets/servicedesk') + '/test/flp.html#app-preview',
        pages: {
			onTheOperationsListGenerated: OperationsListGenerated,
			onTheOperationsObjectPageGenerated: OperationsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

