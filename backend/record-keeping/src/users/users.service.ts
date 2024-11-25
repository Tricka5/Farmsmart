import { BadRequestException, Injectable, InternalServerErrorException } from '@nestjs/common';
import { selectUsers, usersTable } from 'src/db/schema';
import { db } from 'src/db';
import { eq } from 'drizzle-orm';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class UsersService {
  constructor(private jwtService: JwtService) {}

  // Get a user by ID
  async getUserById(userId: selectUsers['userid']): Promise<selectUsers | null> {
    const [user] = await db
      .select()
      .from(usersTable)
      .where(eq(usersTable.userid, userId))
      .execute();
    return user || null;

  }
  
  


async  getUserByEmail(email: string): Promise<selectUsers | null> {
  try {
    
    // Query to select the user by email
    const [user] = await db
      .select()
      .from(usersTable)
      .where(eq(usersTable.email, email)) // Filter by the email
      .execute();

    if (user) {
      return user; // Return the user object if found
    } else {
      return null; // Return null if no user is found
    }
  } catch (error) {
    throw new InternalServerErrorException(error,'Could not retrieve user'); // Throw error or handle it based on your needs
  }
}



  // Get all users
  async getAllUsers(): Promise<selectUsers[] | null> {
    return await db
      .select()
      .from(usersTable)
      .execute();
  }

  // Create a new user
  async createUser(
    firstname: string,
    lastname: string,
    profilepicture: string,
    email: string,
    password: string
  ): Promise<any> {
    try {
      // Hash the password
      const hashedPassword = await bcrypt.hash(password, 12);
  
      // User data to be inserted into the database
      const data = {
        firstname,
        lastname,
        profilepicture,
        email,
        password: hashedPassword,
        activationstatus: false, // Set default value for activationstatus (true or false)
      };
  
      // Insert user into the database and get the inserted user back
      const result = await db
        .insert(usersTable)
        .values(data)
        .returning();
  
      const user = result[0]; // Extract the user from the result
  
      // Generate a JWT token for the user using JwtService
      const token = await this.jwtService.signAsync(
        { userid: user.userid, email: user.email }, // Payload: include necessary info (don't include password)
        { secret: 'your_jwt_secret_key', expiresIn: '1h' } // Secret key and expiration
      );
  
      // Return the user along with the JWT token
      return {
        user: {
          userid: user.userid,
          firstname: user.firstname,
          lastname: user.lastname,
          email: user.email,
          profilepicture: user.profilepicture,
          activationstatus:user.activationstatus,
        },
        access_token: token, // Include the JWT token in the response
      };
    } catch (error) {
      throw new InternalServerErrorException(error,'Failed to create user');
    }
  }
  
  // Authenticate a user by email and password
  async getAuthenticatedUser(
    email: string,
    password: string
  ): Promise<{ access_token: string }> {
    const user = await db
      .select()
      .from(usersTable)
      .where(eq(usersTable.email, email))
      .execute();

    if (user.length === 0 || !(await bcrypt.compare(password, user[0].password))) {
      throw new InternalServerErrorException('Invalid credentials');
    }

    const result = { sub: user[0].userid, firstname: user[0].firstname };
    return {
      access_token: await this.jwtService.signAsync(result) // Use JwtService here as well
    };
  }



async updateActivationStatusById(userId: number, activationStatus: boolean): Promise<void> {
  try {
    // Ensure the object passed to `set()` matches the schema
    await db
      .update(usersTable)
      .set({ activationstatus: activationStatus }) // This should work as long as `activationstatus` is in the schema
      .where(eq(usersTable.userid, userId));

  } catch (error) {
    throw new InternalServerErrorException('Could not update activation status');
  }
}
async updateActivationStatusByEmail(email: string, activationStatus: boolean): Promise<void> {
  try {

    // Update the 'activationstatus' field in the 'usersTable' where the email matches
    await db
      .update(usersTable) // Specify the table to update
      .set({ activationstatus: activationStatus }) // Set the new activation status value
      .where(eq(usersTable.email, email)); // Match the row by email address

    // Log a success message
  } catch (error) {
    // Log any error that occurs and throw an internal server error
    throw new InternalServerErrorException(error,'Could not update activation status by email');
  }
}


}
