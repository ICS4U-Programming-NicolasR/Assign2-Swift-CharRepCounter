import Foundation

/**
 * Reads a file and calculates mean median and mode.
 *
 * @author  Mr. Riscalas
 * @version 1.0
 * @since   2023-03-22
 */

func repCalc(characters: [Character]) -> Int {
    // set the max num to a default of 1
    var maxNumRep = 1
    var currentNumRep = 1
    // store the data of the first character in currentChar
    var currentChar = characters[0]
    for i in 1..<characters.count {
        // If it repeats increase the repeat by one
        if characters[i] == currentChar {
            currentNumRep += 1
        } else {
            // if it doesn't repeat set a new default checker
            currentChar = characters[i]
            currentNumRep = 1
        }
        // if the repetitions outway the maximum repitition set the new one
        if currentNumRep > maxNumRep {
            maxNumRep = currentNumRep
        }
    }
    return maxNumRep
}

func main() {
    // Give permissions to everything
    do {
        let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        try FileManager.default.setAttributes([.posixPermissions: NSNumber(value: 0o777)], ofItemAtPath: documentsURL.path)
    } catch {
        print("Error setting permissions: \(error)")
    }
    // Constants to appease checkstyle
    let FILE_INPUT_STRING = "1"
    let CONSOLE_INPUT_STRING = "2"
    let OUTPUT_FILE = "output.txt"
    // Set the file path
    let fileManager = FileManager.default
    let OUTPUT_FILE_NAME = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(OUTPUT_FILE)
    // Clear the file if it exists
    do {
        let fileHandle = try FileHandle(forWritingTo: OUTPUT_FILE_NAME)
        fileHandle.truncateFile(atOffset: 0)
        fileHandle.closeFile()
    } catch let error {
        print("An error occurred while clearing the file: \(error)")
    }
    // Create the file if it exists
    if !fileManager.fileExists(atPath: OUTPUT_FILE_NAME.path) {
        let success = fileManager.createFile(atPath: OUTPUT_FILE_NAME.path, contents: nil, attributes: nil)
        if !success {
            print("Error creating file")
        } else {
        }
    }
    // Check if they want to input from a file or the console
    print("Press 1 if you have a file of inputs or press 2 just for a console input")
    let INPUT_STRING = readLine() ?? ""
    
    if FILE_INPUT_STRING == INPUT_STRING {
        print("What is the name of the file?")
        let INPUT_FILE_NAME = readLine() ?? ""
        
        // Ask what they would like to output to
        print("Press 1 if you would like to output to a file or 2 for the console")
        var outputType = readLine() ?? ""
        
        // If they have entered an invalid input then set to a default
        if !outputType.elementsEqual(FILE_INPUT_STRING) && !outputType.elementsEqual(CONSOLE_INPUT_STRING) {
            print("The type you have entered is invalid")
            print("Now defaulting to file type")
            outputType = FILE_INPUT_STRING
        }
        // Create a new Scanner object to read from the file
        var stringsArray: [String]? = nil
        do {
            let fileContent = try String(contentsOfFile: INPUT_FILE_NAME)
            // split the file into an array by newline
            stringsArray = fileContent.components(separatedBy: .newlines)
        } catch {
            print("File not found!")
        }
        var repeatedChar = 0
        do {
            let fileHandle = try FileHandle(forWritingTo: OUTPUT_FILE_NAME)
            fileHandle.seekToEndOfFile()

            // convert to character array then calculate the problem
            for i in 0..<stringsArray!.count {
                let CHARACTER_LINE_ARRAY = Array(stringsArray![i])
                repeatedChar = repCalc(characters: CHARACTER_LINE_ARRAY)

                // dependent on how the user wants to output, output
                if outputType.elementsEqual(FILE_INPUT_STRING) {
                    let data = "\(repeatedChar)\n".data(using: .utf8)
                    fileHandle.write(data!)
                } else {
                    print(repeatedChar)
                }
            }

            fileHandle.closeFile()
        } catch let error {
            print("An error occurred while writing to file: \(error)")
        }
    } else if INPUT_STRING.elementsEqual(CONSOLE_INPUT_STRING) {
        // Ask the user for a string
        print("What is the string you'd like to check?")
        // Convert it to character Array
        let CHARACTER_ARRAY = Array(readLine() ?? "")
        
        // Check the desired output type
        print("Press 1 if you would like the output to be to a file or 2 for the console")
        var outputType = readLine() ?? ""
        
        // Check if the input is valid
        if !outputType.elementsEqual(FILE_INPUT_STRING) && !outputType.elementsEqual(CONSOLE_INPUT_STRING) {
            print("You have entered an invalid type")
            print("Defaulting now to file type")
            outputType = FILE_INPUT_STRING
        }
        
        var charRepeatedNum = 0
        
        // Call the function
        charRepeatedNum = repCalc(characters: CHARACTER_ARRAY)
        // Check the desired output type and properly display
        if outputType == FILE_INPUT_STRING {
            do {
                let data = Data("\(OUTPUT_FILE_NAME)".utf8)
                try data.write(to: OUTPUT_FILE_NAME)
            } catch {
                print("An error occurred while writing to the file: ")
                print(error.localizedDescription)
            }
        } else {
            print(charRepeatedNum)
        }
        // If the user enters an invalid input at the beginning:
    } else {
        print("That's not a correct input.")
    }
}

main()