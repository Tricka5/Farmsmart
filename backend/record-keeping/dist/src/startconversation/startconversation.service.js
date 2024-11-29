"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StartconversationService = void 0;
const common_1 = require("@nestjs/common");
let StartconversationService = class StartconversationService {
    create(createStartconversationDto) {
        return 'This action adds a new startconversation';
    }
    findAll() {
        return `This action returns all startconversation`;
    }
    findOne(id) {
        return `This action returns a #${id} startconversation`;
    }
    update(id, updateStartconversationDto) {
        return `This action updates a #${id} startconversation`;
    }
    remove(id) {
        return `This action removes a #${id} startconversation`;
    }
};
exports.StartconversationService = StartconversationService;
exports.StartconversationService = StartconversationService = __decorate([
    (0, common_1.Injectable)()
], StartconversationService);
//# sourceMappingURL=startconversation.service.js.map