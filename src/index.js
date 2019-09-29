$(document).ready(function() {
  var mathFieldSpan = document.getElementById("math-field");
  var MQ = MathQuill.getInterface(2);
  var mathField = MQ.MathField(mathFieldSpan, {
    spaceBehavesLikeTab: true,
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
