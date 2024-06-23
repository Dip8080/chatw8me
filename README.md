# chatw8me
Check out the live demo of the application [here](https://chatw8me.web.app/).
## Project Description
This project is a basic chat application built using Flutter and Firebase. The application includes essential features such as chat functionality, notifications, and user login/logout. It is structured following a feature-first approach and utilizes the specified packages: `flutter_riverpod`, `flutter_hooks`, and `go_router`.
## demo user
- rahim@gmail.com , pass:123456 
- karim@gmail.com , pass:123456
## Features
- **Chat Functionality:** Users can send and receive messages in real-time.
- **Notifications:** Push notifications for new messages.
- **Login/Logout:** User authentication and session management.

## Project Structure
The project follows a feature-first approach to maintain a clean and scalable architecture. Each feature has its own directory, encapsulating its widgets, state management, and business logic.

## Packages Used
- `flutter_riverpod`: For state management.
- `flutter_hooks`: For enhanced stateful widget functionality.
- `go_router`: For routing and navigation.

## Setup Instructions

### Prerequisites
- Flutter SDK
- Firebase account

### Steps to Run the Project Locally

1. **Clone the repository:**
    ```sh
    git clone https://github.com/Dip8080/chatw8me
    ```
2. **Navigate to the project directory:**
    ```sh
    cd flutter_chat_app
    ```
3. **Install dependencies:**
    ```sh
    flutter pub get
    ```
4. **Set up Firebase:**
    - Create a new project in the Firebase Console.
    - Add an Android app and an iOS app to your Firebase project.
    - Download the `google-services.json` file and place it in the `android/app` directory.
    - Download the `GoogleService-Info.plist` file and place it in the `ios/Runner` directory.

5. **Enable Authentication:**
    - In the Firebase Console, go to Authentication and enable Email/Password sign-in method.

6. **Run the application:**
    ```sh
    flutter run
    ```


### Firebase Configuration
Make sure to follow the official Firebase documentation to correctly set up your Firebase project and configure the necessary files in your Flutter project.

### Directory Structure
lib/
├── features/
│ ├── auth/
│ │ ├── data/
│ │ ├── presentation/
│ │ └── ...
│ ├── chat/
│ │ ├── data/
│ │ ├── presentation/
│ │ └── ...
│ └── ...
├── main.dart
└── ...


### State Management
`flutter_riverpod` is used for state management to ensure a reactive and maintainable application state.

### Routing
`go_router` is utilized for handling navigation and routing within the application, providing a simple and flexible approach to managing app routes.

## Live Demo
click [Chatw8me](https://chatw8me.web.app/)

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request for any feature requests or bug fixes.

