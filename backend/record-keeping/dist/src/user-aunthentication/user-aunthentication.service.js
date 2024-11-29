"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserAunthenticationService = void 0;
const common_1 = require("@nestjs/common");
const schema_1 = require("../db/schema");
const drizzle_orm_1 = require("drizzle-orm");
const db_1 = require("../db");
const bcrypt = require("bcrypt");
const jwt_1 = require("@nestjs/jwt");
let UserAunthenticationService = class UserAunthenticationService {
    constructor(jwtService) {
        this.jwtService = jwtService;
    }
    async updateUserPassword(email, newPassword) {
        try {
            const user = await db_1.db
                .select()
                .from(schema_1.usersTable)
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email))
                .execute();
            if (user.length === 0) {
                throw new common_1.InternalServerErrorException('User not found');
            }
            const hashedPassword = await bcrypt.hash(newPassword, 12);
            const result = await db_1.db
                .update(schema_1.usersTable)
                .set({ password: hashedPassword })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email))
                .returning();
            return {
                message: 'Password updated successfully!',
                user: {
                    email: user[0].email,
                    firstname: user[0].firstname,
                    lastname: user[0].lastname,
                },
            };
        }
        catch (error) {
            throw new common_1.InternalServerErrorException('Failed to update password', error);
        }
    }
};
exports.UserAunthenticationService = UserAunthenticationService;
exports.UserAunthenticationService = UserAunthenticationService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [jwt_1.JwtService])
], UserAunthenticationService);
//# sourceMappingURL=user-aunthentication.service.js.map