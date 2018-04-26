# Reducing-Reducer

An example of a Reducer in TW context.

`Reducer` is the actual reducer.
`Router` is also a reducer that works on the output of `Reducer`.

These two things are separated to save the 'Reducer' any knowledge of UI.

App is a simple validation flow - you either fill every text field or go back to square one.
