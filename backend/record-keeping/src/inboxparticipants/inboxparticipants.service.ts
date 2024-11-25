import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { CreateInboxparticipantDto } from './dto/create-inboxparticipant.dto';
import { UpdateInboxparticipantDto } from './dto/update-inboxparticipant.dto';
import { inboxParticipantsTable, insertInboxParticipants, selectInboxParticpants, selectUsers, usersTable } from 'src/db/schema';
import { db } from 'src/db';
import { countDistinct, eq, inArray, sql } from 'drizzle-orm';
import { inboxTable } from 'src/db/schema';
@Injectable()
export class InboxparticipantsService {
  async addParticipant(data:insertInboxParticipants){
    const [inboxParticipant]= await db
      .insert(inboxParticipantsTable)
      .values(data)
      .returning();
      return inboxParticipant;
  }catch(error){
    console.error('failed creating inbox participants',error);
    throw new InternalServerErrorException('failed creating inbox participants');
  }


  
  async getInboxParticipant(userId:selectInboxParticpants['userid']):Promise<selectInboxParticpants|null>{
    const [inboxparticipant]= await db
      .select()
      .from (inboxParticipantsTable)
      .where(eq(inboxParticipantsTable.userid,userId))
      .execute();

      return inboxparticipant || null;
  }

  async getAllinbox(ids: number[]): Promise<selectInboxParticpants[] | null> {
    try {
      const results = await db
        .select()
        .from(inboxParticipantsTable)
        .where(sql`${inboxParticipantsTable.userid} IN (${sql.join(ids, ',')})`) // Use raw SQL
        .execute();
  
      return results.length > 0 ? results : null; // Return null if no results found
    } catch (error) {
      console.error('Error fetching inbox participants:', error);
      return null; // Handle the error appropriately
    }
  }


  
  async getUsers(ids: number[]): Promise<selectInboxParticpants[] | null> {
    console.log('I am in service', ids);
  
    if (ids.length === 0) {
      return null; // Return null if the input array is empty
    }
  
    try {
      const result = await db.query.inboxParticipantsTable.findMany({
        where: (inboxParticipantsTable, { or, eq }) => {
          // Create an array of conditions for each ID
          const conditions = ids.map(id => eq(inboxParticipantsTable.inboxid, id));
          return or(...conditions); // Combine the conditions with 'OR'
        },
      });
  
      console.log('Fetched result:', result);
      return result; // Return the fetched result
    } catch (error) {
      console.error('Error fetching users:', error);
      return null; // Optionally handle error scenarios
    }
  }
  
  async getUserFromUsersTable(userids: number[], userIdCurrent: number): Promise<selectUsers[] | null> {
    try {
      const result = await db.query.usersTable.findMany({
        where: (inboxParticipantsTable, { or, eq, not }) => {
          // Create an array of conditions for each ID, excluding userIdCurrent
          const conditions = userids
            .filter(id => id !== userIdCurrent) // Filter out the current user ID
            .map(id => eq(usersTable.userid, id));
          
          // Combine the conditions with 'OR'
          return or(...conditions);
        },
      });
  
      console.log('Fetched users for:', result);
      return result; // Return the fetched result
    } catch (error) {
      console.error('Error fetching users:', error);
      return null; // Optionally handle error scenarios
    }
  }
  




async getCurrentInbox(otheruser: number, currentuser: number) {
  const users = [otheruser, currentuser];

  try {
    const result = await db
      .select({ inboxid: inboxParticipantsTable.inboxid })
      .from(inboxParticipantsTable)
      .where(inArray(inboxParticipantsTable.userid, users))
      .groupBy(inboxParticipantsTable.inboxid)
      .having(sql`${countDistinct(inboxParticipantsTable.userid)} = ${users.length}`) // Raw SQL expression
      .execute();

    if (result.length === 0) {
      throw new NotFoundException(`Inbox not found for users: ${otheruser}, ${currentuser}`);
    }

    return result;
  } catch (error) {
    console.error('Error fetching inbox for users:', otheruser, currentuser, error);
    throw new InternalServerErrorException('Failed to retrieve inbox');
  }
}

    
  
  
}
