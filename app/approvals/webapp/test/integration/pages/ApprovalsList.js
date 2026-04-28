sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'o2c.approvals',
            componentId: 'ApprovalsList',
            contextPath: '/Approvals'
        },
        CustomPageDefinitions
    );
});