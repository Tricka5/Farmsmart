import { Controller, Get, Post, Body, Patch, Param, Delete, HttpException, HttpStatus, BadRequestException, Query } from '@nestjs/common';
import { InboxparticipantsService } from './inboxparticipants.service';
import { CreateInboxparticipantDto } from './dto/create-inboxparticipant.dto';
import { UpdateInboxparticipantDto } from './dto/update-inboxparticipant.dto';
import { selectInboxParticpants, selectUsers } from 'src/db/schema';
import { currentinboxDto } from './dto/currentInbox.dto';


@Controller('inboxparticipants')
export class InboxparticipantsController {
  constructor(private readonly inboxparticipantsService: InboxparticipantsService) {}
  @Get(':inboxparticipantid')
  async getUserById(@Param('inboxparticipantid') inboxidparticipantid:string){
    const inbox_participant_id=Number(inboxidparticipantid);
    const user=await this.inboxparticipantsService.getInboxParticipant(inbox_participant_id);
    if(!user){
      throw new HttpException(`user ${inbox_participant_id} not found`,HttpStatus.NOT_FOUND);
    }
    return user;
  }
  @Get(':id/chat')
  async getAllUsers(@Param('id') id: string): Promise<selectUsers[]> {
    const userIdCurrent = parseInt(id, 10);


    
    // Check if the parsed ID is a valid number
    if (isNaN(userIdCurrent)) {
      throw new BadRequestException('Invalid user ID'); // Handle invalid ID
    }
    //fetching inboxes of current users
    const result= await this.inboxparticipantsService.getAllinbox([userIdCurrent]); // Pass as an array

    console.log(result);

    const inboxIds = result.map(({ inboxid }) => inboxid);
    console.log('inboxid',inboxIds); // This will give you an array of inbox IDs that the current user participates in

    //this should have the users related with the current user i.e that have the same inbox id
    const related_users= await this.inboxparticipantsService.getUsers(inboxIds)
      //destructure

      const usersFromRelatedUsers = related_users.map(({ userid }) => userid);
    //given related users, we want to fetch from users table

    const users= await this.inboxparticipantsService.getUserFromUsersTable(usersFromRelatedUsers,userIdCurrent);

    return users
  }
  
  @Get(':id/CheckSimilars')
async getUsersWithSimilarInbox(@Param('id') id: string): Promise<selectInboxParticpants[]> {
  const userIds = id.split(',').map(Number); // Expecting a comma-separated string of IDs

  // Validate that all parsed IDs are numbers
  if (userIds.some(isNaN)) {
    throw new BadRequestException('Invalid user IDs'); // Handle invalid IDs
  }

  console.log('Received IDs:', userIds);
  return await this.inboxparticipantsService.getUsers(userIds); // Pass as an array
}
@Get('currentinbox/:otheruser/:currentuser')
async getCurrentInbox(@Param() params: any) {
  console.log('happy!!!!!', params);
  try {
    // Destructure properties directly from the params
    const { otheruser, currentuser } = params;

    console.log('Received otheruser:', otheruser, 'Received currentuser:', currentuser);

    // Call the service method with destructured variables
    return await this.inboxparticipantsService.getCurrentInbox(otheruser, currentuser);
  } catch (error) {
    console.error('Error fetching current inbox hahaha:', error);
    throw new HttpException('Internal server error hahaha', HttpStatus.INTERNAL_SERVER_ERROR);
  }
}


}
