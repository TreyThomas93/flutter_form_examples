# flutter_form_examples

#### form example one

basic form example using text editing controllers created in the parent widget and passed to the text form fields. text form field values are inserted into text controllers and the values are pulled on submission.

#### form example two

this form example uses Riverpods Notifer to hold a "form model" state that I then use throughout all of my form components. I handle try/catch inside the calling widget. But I tend to try to funnel all exceptions to the provider observer, and this doesnt allow for that. I still think this needs improvement on my end. I am looking for advice on if this is best way to go about this.

#### form example three

this form example is what I currently use for my production apps. It uses Riverpods Notifer to hold a "form model" state that I then use throughout all of my form components. And my controller holds state values derived from a sealed union class. Then i use a ref.listen to then update the ui according to its state, such as loading, snackbar, navigate to another page, ect. I still think this needs improvement on my end. I am looking for advice on if this is best way to go about this. I am currently using a provider observer to catch all of my provider error. I much rather funnel all errors/exceptions to a single location than creating a separate logger provider that i need to call at every event exception.

---

I know there isnt a "one size fits all" for how to handle this. For simple forms, using example one is typically my go to. But for more sophisticated forms, I tend to go the example three route.