import { Module } from '@nestjs/common';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from './constants';
import { JwtService } from '@nestjs/jwt';
import { OtpService } from 'src/otp/otp.service';
import { EmailService } from 'src/email/email.service';

@Module({
  imports:[
    
    JwtModule.register({
      global:true,
      secret:jwtConstants.secret,
      signOptions:{expiresIn:'60s'},
    }),
  ],
  controllers: [UsersController],
  providers: [UsersService,OtpService,EmailService],
  exports:[UsersService]
})
export class UsersModule {}
