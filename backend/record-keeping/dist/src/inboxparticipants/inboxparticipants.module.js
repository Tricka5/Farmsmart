"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.InboxparticipantsModule = void 0;
const common_1 = require("@nestjs/common");
const inboxparticipants_service_1 = require("./inboxparticipants.service");
const inboxparticipants_controller_1 = require("./inboxparticipants.controller");
let InboxparticipantsModule = class InboxparticipantsModule {
};
exports.InboxparticipantsModule = InboxparticipantsModule;
exports.InboxparticipantsModule = InboxparticipantsModule = __decorate([
    (0, common_1.Module)({
        controllers: [inboxparticipants_controller_1.InboxparticipantsController],
        providers: [inboxparticipants_service_1.InboxparticipantsService],
    })
], InboxparticipantsModule);
//# sourceMappingURL=inboxparticipants.module.js.map