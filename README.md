# Pomodoro Timer :clock9:
This is a timer app that resembles real pomodoro timer by turning countdown setter. It is a great looking app with UI and UX that brings joy and satisfaction while using. User can set the time by turning the clock and start countdown. App helps to stay focused and keep a high level of productivity throughout the day by managing the breaks between work.


![alt-text](https://github.com/ptuzinek/Pomodoro_App/blob/master/PomodoroAppIntroGifLarge.gif)

# Developer notes 👾
The Application was build using BLoC architecture. Its performance was optimized by profiling the app using DevTools and by minimizing widgets rebuilds using Android Studio's tools for tracking builds. The costly PomodoroTimer widget performance was enhanced by the use of const widgets that are not rebuild even when its parent is rebuilding. Also the buildWhen method was used to minimize number of re-builds.
Code responsible for the animation of turning the clock is implemented inside the UI code.


# Functionalities :gear: 
- Turning clock for setting the countdown time.
- Clock can be rotated infinitely.
- Clock resets to 0 after going over 59 minutes when setting countdown time (turning the clock).
- Start/Pause button and Skip button for skipping breaks.
- Clock turns corresponding to the countdown.
- After countdown is over, the score is increased by 1.
- Progress Bar indicating the finished sessions and the sessions that left.
- Long breaks after 4th focus session.
- Autoplay
