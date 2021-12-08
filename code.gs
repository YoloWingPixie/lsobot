/********************************************************************************************************************************   
*   Copyright 2021 BadMojo11
*   https://github.com/BadMojo11
*
*   License Info
*
*
*   Setup/Config
*
*   1. Copy and overwrite any code in the code.gs file into App Script of your spreadsheet
*  
*   2. Enter sheet name where data is to be written in the GLOBAL VARIABLES section
*
*   3. Publish > Deploy as web app 
*    - Enter Project Version name and click 'Save New Version' 
*    - Set security level and enable service (most likely execute as 'me' and access 'anyone, even anonymously) 
*
*   4. Copy the 'Current web app URL' and post this in your LsoBot.ps1 form/script action 
*
*   5. Insert column names on your destination sheet matching the parameter names of the data you are passing in (exactly matching case)
*
***************************************************************************************************************************************/

/********************
 * GLOBAL VARIABLES  *
 ********************/ 

// New script property service for handling data
var script_properties = PropertiesService.getScriptProperties();

// Define target sheet - Replace with your target sheet name
var sheet_name = "Grades";

/************
 *  METHODS  *
 ************/ 

// Comment out if you do not want to expose get method
function doGet(e){
  return handleResponse(e);
}

// Comment out if you do not want to expose post method
function doPost(e){
  return handleResponse(e);
}

// Main method: handle response
function handleResponse(e) {
  
  // Prevents overwriting data by preventing concurrent access
  var public_lock = LockService.getPublicLock();

  // Define lock wait time: currently set to 30 seconds
  public_lock.waitLock(30000);
  
  try {
    
    // next set where we write the data - you could write to multiple/alternate destinations
    var doc = SpreadsheetApp.openById(script_properties.getProperty("key"));
    
    // Get sheet by name
    var sheet = doc.getSheetByName(sheet_name);
    
    // Define header as first row
    var headRow = e.parameter.header_row || 1;
    
    // Get header columns
    var headers = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
    
    // Get next available row in sheet
    var nextRow = sheet.getLastRow()+1;
    
    // Create array 'row'
    var row = []; 
    
    // For statement to loop through header columns
    for (i in headers){

      // Automatically add timestamp to row if your column is named Timestamp
      if (headers[i] == "Timestamp"){ 

        // Add timestamp to the new row
        row.push(new Date());

      } else { 

        // Else use the header name to get the data
        row.push(e.parameter[headers[i]]);
      }
    }

    //Set values in row
    sheet.getRange(nextRow, 1, 1, row.length).setValues([row]);
         
    // Return JSON success results
    return ContentService
          .createTextOutput(JSON.stringify({"result":"success", "row": nextRow}))
          .setMimeType(ContentService.MimeType.JSON);
  } catch(e){
    // IF error, return error result
    return ContentService
          .createTextOutput(JSON.stringify({"result":"error", "error": e}))
          .setMimeType(ContentService.MimeType.JSON);
  } finally {

    //call reGrade here?
    
    //call function getWire
    getWire();

    // Release the lock on the sheet
    public_lock.releaseLock();
  }
}

function getWire() {
  
  // Get the grades sheet - replace with name of your sheet
  var grades_sheet = SpreadsheetApp.getActive().getSheetByName('Grades');

  // Set these values to match the columns in your sheet
  var col_id_comments =  "D";
  var col_id_wire =      "F";

  // Get the current row where the edit is happening
  var row_id = grades_sheet.getLastRow();

  //Get range of comments cell
  var commentsCell = grades_sheet.getRange(col_id_comments + row_id);

  if (commentsCell.isBlank()){
    return;
  } 
  else{
   
    var comments = grades_sheet.getRange(col_id_comments + row_id).getValue();
  
    var wire = grades_sheet.getRange(col_id_wire + row_id);

    var strlength = comments.length -1;

    var lastChar = comments.charAt(strlength);

    if (lastChar=="1" || lastChar=="2" || lastChar=="3" || lastChar=="4"){
      wire.setValue(lastChar);
    }
    else{
      wire.setValue("-");
    }
  }
}
