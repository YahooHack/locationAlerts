//
//  DataPersistence.h
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 4/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  This class is used for accessing file function 

#import <Foundation/Foundation.h>


// this is used for inform controller regarding communication error type
typedef enum {
	UNKNOWN_DP_FOLDER_TYPE = -1,
    COMPLETE_DP_FILE_PATH = 1,
    DOCUMENTS_DP_FOLDER_TYPE = 2,
    CACHES_DP_FOLDER_TYPE = 3
} DATA_PERSISTENCE_FOLDER_TYPE_ENUM;

@interface DataPersistence : NSObject {

}

// This function return application cache directory folder path.
+ (NSString*)getCacheDirectoryPath;

// This function return application document directory folder path. 
+ (NSString*)getDocumentDirectoryPath;

// This function take file name(only file name) in parameter and return string which contain compelete path of file, append file with application folder. 
+ (NSString*)getCompleteFilePath:(NSString*)fileName withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function take file path in parameter and return bool which show file existence.
+ (BOOL) checkFileExistance:(NSString*)fileName withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function take file path in parameter and create this file. if file successfully created then this function return TRUE otherwise FALSE
+ (BOOL) createFile:(NSString*)createFilePath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function take file path in parameter and delete this file. if file successfully delete then this function return TRUE otherwise FALSE
+ (BOOL) removeFile:(NSString*)removeFilePath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function take folder path in parameter and create this folder. if file successfully created then this function return TRUE otherwise FALSE
+ (BOOL) createfolder:(NSString*)createFolderPath withIntermediateDirectorie:(BOOL)createIntermediates attributes:(NSDictionary*)property withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function take file path in parameter and return NSString which show file size. this string contain 0 if file size equal to zero
+ (NSString*) getFileSize:(NSString*)filePath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function take folder path in parameter and return array that contain all files and folder in this folder path.
+ (NSArray*) getDirectoryContentsAtPath:(NSString*)folderPath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function take folder path in parameter and return NSDirectoryEnumerator that contain all files and folder in this folder path.
+ (NSDirectoryEnumerator*) getDirectoryEnumerationAtPath:(NSString*)folderPath withDPFolderType:(DATA_PERSISTENCE_FOLDER_TYPE_ENUM)folderType;

// This function move file from one path to another, this function complete source and destination file path
+ (BOOL) moveFileFromSource:(NSString*)sourceFilePath toDestination:(NSString*)destinationFilePath;
@end


