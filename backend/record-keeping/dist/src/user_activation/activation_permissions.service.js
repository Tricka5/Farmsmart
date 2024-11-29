"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ActivationService = void 0;
const common_1 = require("@nestjs/common");
const schema_1 = require("../db/schema");
const db_1 = require("../db");
const drizzle_orm_1 = require("drizzle-orm");
let ActivationService = class ActivationService {
    async updateActivationStatusById(userId, activationStatus) {
        try {
            if (isNaN(userId)) {
                throw new Error('Invalid userId');
            }
            const result = await db_1.db
                .update(schema_1.usersTable)
                .set({ activationstatus: activationStatus })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.userid, userId));
            if (result.length === 0) {
                throw new common_1.NotFoundException(`User with ID ${userId} not found`);
            }
            console.log(`User with ID ${userId} activation status updated to ${activationStatus}`);
        }
        catch (error) {
            console.error('Error updating activation status:', error);
            throw new common_1.InternalServerErrorException(`Could not update activation status for user with ID ${userId}`);
        }
    }
    async updateActivationStatusByEmail(userId, activationStatus) {
        try {
            if (isNaN(userId)) {
                throw new Error('Invalid userId');
            }
            const result = await db_1.db
                .update(schema_1.usersTable)
                .set({ activationstatus: activationStatus })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.userid, userId));
            if (result.length === 0) {
                throw new common_1.NotFoundException(`User with ID ${userId} not found`);
            }
            console.log(`User with ID ${userId} activation status updated to ${activationStatus}`);
        }
        catch (error) {
            console.error('Error updating activation status:', error);
            throw new common_1.InternalServerErrorException(`Could not update activation status for user with ID ${userId}`);
        }
    }
};
exports.ActivationService = ActivationService;
exports.ActivationService = ActivationService = __decorate([
    (0, common_1.Injectable)()
], ActivationService);
//# sourceMappingURL=activation_permissions.service.js.map