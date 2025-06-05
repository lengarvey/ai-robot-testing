# Notes on the various testing performed


## `toy-robot-no-rules`

### Prompt and Process

The prompt was simple:

> Using the description in @PROBLEM.md build the toy robot. Ask any clarifying questions you might have along the way.

The problem was solved quite well in "one shot". Confusingly the prompt specifically told the AI to "Ask any clarifying questions". The AI said "Let me ask a few clarifying questions before I start building" listed some great questions, but then proceeded to say:

> For now, I'll assume Python since it's commonly used for such simulations and provides good readability. Let me start with a basic implementation and you can let me know if you'd like any adjustments.

I find this mildly annoying. If the AI was acting like a "real developer" it would have stopped and actually asked the questions, rather than noting them and then continuing.

### Solution

The AI did a pretty solid job of building a toy robot. This would be a pretty solid implementation for a junior developer. Notably it didn't really use any patterns, or implementation techniques that might demonstrate greater mastery - or make the code easier to maintain going forward. Some of these are highlighted in the `code_review_feedback.md`. The two most significant flaws in my view are the lack of a command pattern which makes the command execution and movement methods pretty complex, and the "lack" of error handling.

I think this demonstrates two significant flaws of "vibe coding":

1. Since it's trained on a lot of mediocre code - the output is pretty average. We need to prompt it to do better.
2. Because the prompt didn't speak of what error handling should look like it didn't work on that. This is a common flaw for junior devs, and lots of average code - so because of the stochastic but stastically "likely" nature of the output it doesn't ask or consider this.

We can do better - I believe with `.rules` that prompt the AI to do better.

Aesthetically the code is also structured really poorly. Everything in a single folder. Yuck.

### Testing

Tests were built, but there was no consideration for doing TDD. I think a slower approach would be better, and allow the human to more readily understand the output. That said I know a lot of people appreciate the whole "one shot" aspect of coding like this. I believe that it's a bad idea for professional product development to just let the AI run wild like this. There's a tendency for the AI to do "too much". I'd rather it do too little, but do it really, really well.

### The AI output is interesting

I hadn't observed the AI output in this detail before. For example:

**Use Tool: thinking (toolu_019JU9GYboSuUgzuV8VF35xS)**
```json
{
  "content": "Let me think about the structure of this toy robot simulator:\n\n1. I need a Robot class that tracks:\n   - Position (x, y)\n   - Direction (NORTH, SOUTH, EAST, WEST)\n   - Whether it's been placed on the table\n\n2. I need a Table class or constants for:\n   - Table dimensions (5x5)\n   - Validation of positions\n\n3. Commands to implement:\n   - PLACE X,Y,F - place robot at position with facing direction\n   - MOVE - move one unit forward in current direction\n   - LEFT - rotate 90 degrees left\n   - RIGHT - rotate 90 degrees right  \n   - REPORT - output current position and direction\n\n4. Rules to enforce:\n   - Robot must be placed before other commands work\n   - Robot cannot move off the table (0-4 for both x and y)\n   - Invalid commands should be ignored\n   - PLACE command must have valid coordinates and direction\n\nLet me start with a Python implementation that can read from standard input or a file."
}
```

This is really interesting and allows us to peek under the covers a little bit (we could always look at the requests being made to claude).


## toy-robot-pause-ask-rule


### Prompt and Process

Once again the prompt was simple:

> Using the description in @PROBLEM.md build the toy robot. Ask any clarifying questions you might have along the way.

But this time I included a rule that would hopefully force the AI to stop and ask for my input:

> As a coding assistant you are to stop execution and ask clarifying questions when necessary. If you are unsure about the user's intent, ask for clarification.

This worked well, you can see the rule being included in the prompt that Zed makes:

```
</files>
<user_rules>
The user has specified the following rules that should be applied:

Rules title: Ask for Clarification
As a coding assistant you are to stop execution and ask clarifying questions when necessary. If you are unsure about the user's intent, ask for clarification.
</user_rules>
</context>
```

The AI did stop and ask for my input:

I provided the following:

```
1. Use Ruby 2. Use a command line interface 3. Use good design and structure accordingly. Use your best judgement to create folders for code and tests. 4. Simple text output. 5. Unit tests using rspec 6. Provide feedback around invalid commands.
```

But I did realise that my environment didn't have a good version of Ruby installed. After fixing that everything worked smoothly.

### Solution

I think the AI did a much better job at this one. The design of the system is better, with some evidence of patterns and OO design being used. There's definitely some improvements to be made, but overall a much stronger effort. I think this comes down to being able to provide more clarification rather than the AI just going off and doing whatever it wanted.

### Testing

Once again TDD wasn't used, but the tests this time were written well. The AI does seem to have a fascination with creating manual test cases rather than relying on the specs. My next runs are going to focus more on TDD, and getting the AI to slow down and ask to proceed more frequently.

I know the tooling allows this to some degree, but it isnt fun to be asked if the AI can run a command, it's fun to be treated more like a pair - where design decisions are being made - or even to confirm that the decisions being made are the correct ones.
