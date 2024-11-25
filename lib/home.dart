import 'dart:io'; // Import the Dart I/O library for file system operations.
import 'package:file_picker/file_picker.dart'; // Import the file_picker package for selecting directories/files.
import 'package:flutter/material.dart'; // Import the Flutter material library for UI components.

// Define the main HomePage widget, which is stateful to allow dynamic updates.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState(); // Create the associated state object.
}

// State class for HomePage, containing the logic and state variables.
class _HomePageState extends State<HomePage> {
  String? selectedPath; // Variable to store the selected directory path.
  String fileName = "example.txt"; // Default name of the file to be saved.

  // Default content to be written to the file.
  String fileContent =
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate hic dolore cumque dignissimos quos error vitae explicabo. Quas at quod autem ipsam modi quasi, a nam assumenda debitis. Esse fugiat sed, molestias voluptates ea minus nisi delectus tempora! Voluptas adipisci vitae quod ipsum corporis praesentium?";

  // Function to open a directory picker and get the selected directory path.
  void filePicker() async {
    try {
      // Show directory picker and store the result.
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      // Update the state with the selected directory path or a fallback message.
      directoryPath != null
          ? setState(() {
              selectedPath = directoryPath;
            })
          : setState(() {
              selectedPath = "No Directory selected";
            });
    } catch (e) {
      // Handle errors during directory selection.
      setState(() {
        selectedPath = "Error on Directory selection";
      });
    }
  }

  // Function to save a file with the default content in the selected directory.
  void saveFile() async {
    // Check if a valid directory has been selected.
    if (selectedPath == null || selectedPath == "No Directory selected") {
      setState(() {
        showMessage(
            "Select a directory first."); // Show a message if no directory is selected.
      });
      return; // Exit the function early if no valid directory is selected.
    }

    try {
      // Create the full file path by combining the directory and file name.
      String finalPath = "$selectedPath/$fileName";
      final file = File(finalPath); // Create a File object.

      // Write the default content to the file.
      await file.writeAsString(fileContent);

      // Show a success message.
      showMessage("File saved successfully at path: $finalPath");
    } catch (e) {
      // Handle errors during file saving.
      setState(() {
        showMessage("Error Saving File $e");
      });
    }
  }

  // Build method to construct the UI of the application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Permission"), // App bar title.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the UI elements vertically.
          children: [
            const Text("Access Permission"), // A label for the page.
            const SizedBox(
              height: 10, // Spacing between elements.
            ),
            ElevatedButton(
              onPressed:
                  filePicker, // Trigger file picker when button is pressed.
              child: const Text("Pick File"),
            ),
            ElevatedButton(
              onPressed:
                  saveFile, // Trigger save file function when button is pressed.
              child: const Text("Save File"),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a message using a Snackbar.
  void showMessage(String messagee) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(messagee)));
  }
}
