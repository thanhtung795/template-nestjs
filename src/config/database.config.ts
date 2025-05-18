import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { UserEntity } from './modules/users/users.entity';
import * as dotenv from 'dotenv';

dotenv.config();

export default new DataSource({  
  type: 'postgres',
  host:process.env.DATABASE_HOST,
  port:Number(process.env.DATABASE_PORT),
  username: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASS,
  database: process.env.DATABASE_NAME,
  entities: [UserEntity],
  migrations: [
    "./src/migration/*.ts",
    "./dist/migrations/*{.ts,.js}"
  ],
  //synchronize: true,
  logging: true,

});
