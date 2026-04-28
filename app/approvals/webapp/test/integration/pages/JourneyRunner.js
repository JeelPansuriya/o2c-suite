sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"o2c/approvals/test/integration/pages/ApprovalsList",
	"o2c/approvals/test/integration/pages/ApprovalsObjectPage"
], function (JourneyRunner, ApprovalsList, ApprovalsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('o2c/approvals') + '/test/flp.html#app-preview',
        pages: {
			onTheApprovalsList: ApprovalsList,
			onTheApprovalsObjectPage: ApprovalsObjectPage
        },
        async: true
    });

    return runner;
});

