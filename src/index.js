var MQ;
var mathFieldContainer;
var curAnsSpan;
var curAnsField;
var curExprSpan;
var curExprField;
var mathFieldId = 0;

$(document).ready(function() {
  MQ = MathQuill.getInterface(2);
  mathFieldContainer = document.getElementById("math-fields");
  createMathField();
});

function createMathField() {
  mathFieldContainer.insertAdjacentHTML("beforeend",
    "<div class='equation-field' id='equation-field"+mathFieldId+"'" +
      " onclick='selectMathField("+mathFieldId+")'>" +
    "<span class='field' id='field"+mathFieldId+"'></span>" +
    "<span class='answer-field' id='answer-field"+mathFieldId+"'></span><br/>" +
    "</div>"
  );
  curAnsSpan = document.getElementById("answer-field"+mathFieldId);
  curExprSpan = document.getElementById("field"+mathFieldId);
  curAnsField = MQ.StaticMath(curAnsSpan);
  curExprField = MQ.MathField(curExprSpan, {
    spaceBehavesLikeTab: true,
    leftRightIntoCmdGoes: "up",
    restrictMismatchedBrackets: true,
    supSubsRequireOperand: true,
    autoSubscriptNumerals: true,
    autoCommands: "pi sqrt nthroot",
    autoOperatorNames: "ln log sin cos tan",
    handlers: {
      edit: function(exprField) {
        var answerField =
          MQ(document.getElementById("answer-"+exprField.el().id))
        try {
          var answer =
            Opal.eval("Calculator::Parser.new(%q{"+exprField.latex()+"}).run")
          if(answer == undefined) {
            answerField.latex("");
          } else {
            answerField.latex("="+answer);
          }
        } catch {
          answerField.latex("=");
        }
      },
      enter: function(exprField) {
        if(exprField.latex() != "") { createMathField(); }
      },
      upOutOf: function(exprField) {
        selectMathField(parseInt(exprField.el().id.substring(5)) - 1);
      },
      downOutOf: function(exprField) {
        selectMathField(parseInt(exprField.el().id.substring(5)) + 1);
      }
    }
  });
  selectMathField(mathFieldId);
  mathFieldId++;
}

function selectMathField(id) {
  $("#field"+id).mousedown().mouseup();
}
