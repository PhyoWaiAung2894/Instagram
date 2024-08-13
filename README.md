#  Build like Instagram App

This project is an Instagram-like app built programmatically using UIKit with some parts initialized using Storyboard. The purpose of this app is to provide a hands-on experience with the Model-View-Controller (MVC) design pattern, and demonstrate how to build an app from scratch with mock data, login, and registration functionalities using Firebase.

Features

• Programmatic UI with UIKit: All UI components are created programmatically without using Storyboards or XIB files.
• MVC Architecture: The project follows the MVC design pattern to separate concerns and manage code effectively.
• Mock Data: Includes mock data for posts, comments, and users to simulate a real Instagram feed.
• Firebase Authentication: Users can register and log in using Firebase Authentication.
• User Profiles: Displays user profiles with their posts and information.
• Photo Feed: Simulates a photo feed with mock posts.
• Post Details: Displays details of a post including comments and likes.

 Screenshots

<div align="center">
  <img src="https://github.com/user-attachments/assets/1433b12a-57df-4911-a676-594f8fd97e43" alt="Screenshot 1" width="200" />
  <img src="https://github.com/user-attachments/assets/8af13779-96e8-41b2-9476-9384ce272c24" alt="Screenshot 2" width="200" />
  <img src="https://github.com/user-attachments/assets/9a5d89f5-dd95-4b63-a6c8-3d68430eea09" alt="Screenshot 3" width="200" />
</div>
<div align="center">
  <img src="https://github.com/user-attachments/assets/de4a72bb-c1b8-4fbf-9a4b-6c6cb9185262" alt="Screenshot 4" width="200" />
  <img src="https://github.com/user-attachments/assets/e900d019-d485-430a-8816-ae16d4610fee" alt="Screenshot 5" width="200" />
  <img src="https://github.com/user-attachments/assets/f1ce8884-3d49-4135-80e9-7e5835497f23" alt="Screenshot 6" width="200" />
</div>

### Project Structure

 •	Models: Contains model classes such as User, Post, and Comment.
 •	Views: Contains custom UI components and table view cells.
 •	Controllers: Contains view controllers managing different screens such as login, feed, and profile.
 •	Services: Contains service classes for handling Firebase authentication and data fetching.
 •	Utilities: Contains helper functions and extensions.
 •	Storyboard: Contains the storyboard for initializing navigation tabs.

 ### Usage

 Login

Users can log in using their email and password. If the user doesn’t have an account, they can navigate to the registration screen.

Registration

Users can register by providing an email, password, and username. Upon successful registration, they are logged in and taken to the main feed screen.

Main Feed

The main feed displays a list of mock posts with photos, captions, and likes. Users can tap on a post to view its details and comments.

Profile

The profile screen displays the user’s information and their posts. Users can view the details of their posts by tapping on them.

# Installation Guide

Follow these steps to get the project up and running on your local machine.

## Prerequisites

- **iOS 14.0+**
- **Xcode 15.0+**
- **CocoaPods**
  
## Steps

### 1. Clone the Repository

First, clone the repository to your local machine using the following command:

```bash
git clone https://github.com/PhyoWaiAung2894/Instagram.git
cd Instagram
```

### 2. Install Dependencies

Navigate to the project directory and install the dependencies using CocoaPods:

```bash
pod install
```

### 3. Open the Project in Xcode

```bash
open Instagram.xcworkspace
```

###	4.	Set up Firebase:
####	• Create a Firebase project in the Firebase Console.
#### •	Download the GoogleService-Info.plist file and add it to your Xcode project.
#### •	Enable Firebase Authentication in your Firebase console and set up email/password authentication.
 
###	5.	Run the project:
#### •	Select your target device or simulator.
#### •	Press Cmd + R to build and run the project.




