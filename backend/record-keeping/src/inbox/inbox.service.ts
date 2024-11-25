import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { CreateInboxDto } from './dto/create-inbox.dto';
import { UpdateInboxDto } from './dto/update-inbox.dto';
import { inboxTable, insertInbox } from 'src/db/schema';
import { db } from 'src/db';
import { Inbox } from './entities/inbox.entity';

@Injectable()
export class InboxService {
  async createEntry(data:insertInbox){
    try{
      const [inbox]=await db
      .insert(inboxTable)
      .values(data)
      .returning();
      return inbox;
    }catch(error){
      console.error('Error creating converstaion entry',error);
      throw new InternalServerErrorException('failed creating conversation entry');
    }
  }
}
