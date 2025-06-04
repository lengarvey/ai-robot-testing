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
