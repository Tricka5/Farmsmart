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
exports.UsersService = void 0;
const common_1 = require("@nestjs/common");
const schema_1 = require("../db/schema");
const db_1 = require("../db");
const drizzle_orm_1 = require("drizzle-orm");
const bcrypt = require("bcrypt");
const jwt_1 = require("@nestjs/jwt");
let UsersService = class UsersService {
    constructor(jwtService) {
        this.jwtService = jwtService;
    }
    async getUserById(userId) {
        const [user] = await db_1.db
            .select()
            .from(schema_1.usersTable)
            .where((0, drizzle_orm_1.eq)(schema_1.usersTable.userid, userId))
            .execute();
        return user || null;
    }
    async getUserByEmail(email) {
        try {
            const [user] = await db_1.db
                .select()
                .from(schema_1.usersTable)
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email))
                .execute();
            if (user) {
                return user;
            }
            else {
                return null;
            }
        }
        catch (error) {
            throw new common_1.InternalServerErrorException(error, 'Could not retrieve user');
        }
    }
    async getAllUsers() {
        return await db_1.db
            .select()
            .from(schema_1.usersTable)
            .execute();
    }
    async createUser(firstname, lastname, profilepicture, email, password) {
        try {
            const hashedPassword = await bcrypt.hash(password, 12);
            const data = {
                firstname,
                lastname,
                profilepicture,
                email,
                password: hashedPassword,
                activationstatus: false,
            };
            const result = await db_1.db
                .insert(schema_1.usersTable)
                .values(data)
                .returning();
            const user = result[0];
            const token = await this.jwtService.signAsync({ userid: user.userid, email: user.email }, { secret: 'your_jwt_secret_key', expiresIn: '1h' });
            return {
                user: {
                    userid: user.userid,
                    firstname: user.firstname,
                    lastname: user.lastname,
                    email: user.email,
                    profilepicture: user.profilepicture,
                    activationstatus: user.activationstatus,
                },
                access_token: token,
            };
        }
        catch (error) {
            throw new common_1.InternalServerErrorException(error, 'Failed to create user');
        }
    }
    async getAuthenticatedUser(email, password) {
        const user = await db_1.db
            .select()
            .from(schema_1.usersTable)
            .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email))
            .execute();
        if (user.length === 0 || !(await bcrypt.compare(password, user[0].password))) {
            throw new common_1.InternalServerErrorException('Invalid credentials');
        }
        const result = { sub: user[0].userid, firstname: user[0].firstname };
        return {
            access_token: await this.jwtService.signAsync(result)
        };
    }
    async updateActivationStatusById(userId, activationStatus) {
        try {
            await db_1.db
                .update(schema_1.usersTable)
                .set({ activationstatus: activationStatus })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.userid, userId));
        }
        catch (error) {
            throw new common_1.InternalServerErrorException('Could not update activation status');
        }
    }
    async updateActivationStatusByEmail(email, activationStatus) {
        try {
            await db_1.db
                .update(schema_1.usersTable)
                .set({ activationstatus: activationStatus })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email));
        }
        catch (error) {
            throw new common_1.InternalServerErrorException(error, 'Could not update activation status by email');
        }
    }
    async updateFirstName(email, firstname) {
        try {
            if (!email || !firstname) {
                throw new Error('Invalid input data');
            }
            console.log('chec', email, firstname);
            const result = await db_1.db
                .update(schema_1.usersTable)
                .set({ firstname: firstname })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email));
            if (result.count === 0) {
                throw new Error(`No user found with the email: ${email}`);
            }
            return { message: 'First name updated successfully', updatedRows: result.count };
        }
        catch (error) {
            console.error('Error updating first name:', error);
            throw new Error('Failed to update first name. Please try again later.');
        }
    }
    async updateLastName(email, lastname) {
        try {
            if (!email || !lastname) {
                throw new Error('Invalid input data');
            }
            console.log('chec', email, lastname);
            const result = await db_1.db
                .update(schema_1.usersTable)
                .set({ lastname: lastname })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email));
            if (result.count === 0) {
                throw new Error(`No user found with the email: ${email}`);
            }
            return { message: 'last name updated successfully', updatedRows: result.count };
        }
        catch (error) {
            console.error('Error updating lst name:', error);
            throw new Error('Failed to update last name. Please try again later.');
        }
    }
    async updateProfilePicture(email, profilepicture) {
        try {
            if (!email || !profilepicture) {
                throw new Error('Invalid input data');
            }
            console.log('chec', email, profilepicture);
            const result = await db_1.db
                .update(schema_1.usersTable)
                .set({ profilepicture: profilepicture })
                .where((0, drizzle_orm_1.eq)(schema_1.usersTable.email, email));
            if (result.count === 0) {
                throw new Error(`No user found with the email: ${email}`);
            }
            return { message: ' updated successfully', updatedRows: result.count };
        }
        catch (error) {
            console.error('Error updating :', error);
            throw new Error('Failed to update . Please try again later.');
        }
    }
};
exports.UsersService = UsersService;
exports.UsersService = UsersService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [jwt_1.JwtService])
], UsersService);
//# sourceMappingURL=users.service.js.map