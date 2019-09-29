$(document).ready(function() {
  var mathFieldSpan = document.getElementById("math-field");
  var MQ = MathQuill.getInterface(2);
  var mathField = MQ.MathField(mathFieldSpan, {
    spaceBehavesLikeTab: true,
    restrictMismatchedBrackets: true,
    supSubsRequireOperand: true,
    autoSubscriptNumerals: true,
    autoCommands: "pi sqrt nthroot",
    autoOperatorNames: "ln log sin cos tan",
    handlers: {
      edit: function() {
        try {
          Opal.eval("Calculator::Parser.new(%q{"+mathField.latex()+"}).run");
        } catch {
          document.getElementById("answer").textContent = "";
        }
      }
    }
  });
});
