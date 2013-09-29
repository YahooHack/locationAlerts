//
//  DataPersistence.m
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  This class is used for accessing file function 

#import "DataPersistence.h"


@implementation DataPersistence

#pragma mark Getting Path function
// This function return application cache directory folder path.
+ (NSString*)getCacheDirectoryPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString* cacheDirectory = [paths objectAtIndex:0];
	return cacheDirectory;
}

// This function return application document directory folder path. 
+ (NSString*)getDocumentDirectoryPath
{
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

// This function take file name(only file name) in parameter and return string which contain compelete path of file, append file with application folder. 
+ (NSString*)getCompleteFilePath:(NSString*)fileName withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
    NSString* filePath = @"";
    
    switch (folderType) {
        case DOCUMENTS_DP_FOLDER_TYPE:
        {
            filePath = [[self getDocumentDirectoryPath] stringByAppendingPathComponent:fileName];
            break;
        }
        case CACHES_DP_FOLDER_TYPE:
        {
            filePath = [[self getCacheDirectoryPath] stringByAppendingPathComponent:fileName];
            break;
        }
        case COMPLETE_DP_FILE_PATH:
            filePath = fileName;
            break;
        default:
            filePath = fileName;
            break;
    }
    
	return filePath;
}

#pragma mark File Create/Copy/Delete/Check Existence function
// This function take file path in parameter and return bool which show file existence.
+ (BOOL) checkFileExistance:(NSString*)filePath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
	NSString *completeFilePath = [self getCompleteFilePath:filePath withDPFolderType:folderType];
	
	return [[NSFileManager defaultManager] fileExistsAtPath:completeFilePath];
}

// This function take file path in parameter and create this file. if file successfully created then this function return TRUE otherwise FALSE
+ (BOOL) createFile:(NSString*)createFilePath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
	NSString *completeFilePath = [self getCompleteFilePath:createFilePath withDPFolderType:folderType];
	
	return [[NSFileManager defaultManager] createFileAtPath:completeFilePath contents:nil attributes:nil];
}

// This function take file path in parameter and delete this file. if file successfully delete then this function return TRUE otherwise FALSE
+ (BOOL) removeFile:(NSString*)removeFilePath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
	NSString *completeFilePath = [self getCompleteFilePath:removeFilePath withDPFolderType:folderType];
	
	return [[NSFileManager defaultManager] removeItemAtPath:completeFilePath error:NULL];
}

#pragma mark Folder Create function
// This function take folder path in parameter and create this folder. if file successfully created then this function return TRUE otherwise FALSE
+ (BOOL) createfolder:(NSString*)createFolderPath withIntermediateDirectorie:(BOOL)createIntermediates attributes:(NSDictionary*)property withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
    NSString *completeFilePath = [self getCompleteFilePath:createFolderPath withDPFolderType:folderType];
    
	return [[NSFileManager defaultManager] createDirectoryAtPath:completeFilePath withIntermediateDirectories:createIntermediates attributes:property error:NULL];
}

#pragma mark File Size function
// This function take file path in parameter and return NSString which show file size. this string contain 0 if file size equal to zero
+ (NSString*) getFileSize:(NSString*)filePath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
	NSString *completeFilePath = [self getCompleteFilePath:filePath withDPFolderType:folderType];
	
	NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:completeFilePath error:NULL];
	if(fileAttributes)
	{
		return [[fileAttributes valueForKey:NSFileSize] stringValue];
	}
	return @"0";
}

#pragma mark Get Folder Content function
// This function take folder path in parameter and return array that contain all files and folder in this folder path.
+ (NSArray*) getDirectoryContentsAtPath:(NSString*)folderPath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
    NSString *completeFolderPath = [self getCompleteFilePath:folderPath withDPFolderType:folderType];
    
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:completeFolderPath error:NULL];
}

// This function take folder path in parameter and return NSDirectoryEnumerator that contain all files and folder in this folder path.
+ (NSDirectoryEnumerator*) getDirectoryEnumerationAtPath:(NSString*)folderPath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType
{
	NSString *completeFolderPath = [self getCompleteFilePath:folderPath withDPFolderType:folderType];
	
	return [[NSFileManager defaultManager] enumeratorAtPath:completeFolderPath];
}

// This function move file from one path to another, this function complete source and destination file path
+ (BOOL) moveFileFromSource:(NSString*)sourceFilePath toDestination:(NSString*)destinationFilePath
{
	return [[NSFileManager defaultManager] moveItemAtPath:sourceFilePath toPath:destinationFilePath error:NULL];
}
@end


