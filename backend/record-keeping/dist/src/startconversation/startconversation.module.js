"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StartconversationModule = void 0;
const common_1 = require("@nestjs/common");
const startconversation_service_1 = require("./startconversation.service");
const startcova_controller_1 = require("../startcova.controller");
const inbox_module_1 = require("../inbox/inbox.module");
const inbox_service_1 = require("../inbox/inbox.service");
const inboxparticipants_service_1 = require("../inboxparticipants/inboxparticipants.service");
let StartconversationModule = class StartconversationModule {
};
exports.StartconversationModule = StartconversationModule;
exports.StartconversationModule = StartconversationModule = __decorate([
    (0, common_1.Module)({
        controllers: [startcova_controller_1.StartConversaation],
        imports: [inbox_module_1.InboxModule],
        providers: [startconversation_service_1.StartconversationService, inbox_service_1.InboxService, inboxparticipants_service_1.InboxparticipantsService],
    })
], StartconversationModule);
//# sourceMappingURL=startconversation.module.js.map