var MQ;
var mathFieldContainer;
var buttonsContainer;
var curFieldId;
var answerFields = [];
var exprFields = [];

$(document).ready(function() {
  MQ = MathQuill.getInterface(2);
  mathFieldContainer = document.getElementById("math-fields");
  buttonsContainer = document.getElementById("buttons");
  createMathField();
  addButtons();
});

function createMathField() {
  mathFieldContainer.insertAdjacentHTML("beforeend",
    "<div class='equation-field'>" +
      "<span class='expr-field'></span><span class='answer-field'></span>" +
    "</div>"
  );
  var fields = fieldsArray()
  curFieldId = fields.length - 1;
  fields[curFieldId].classList.add("active");
  fields[curFieldId].addEventListener("click", (e) => { switchField(e); });
  var answerSpans = $(".answer-field");
  answerFields.push(MQ.StaticMath(answerSpans[answerSpans.length-1]));
  var exprSpans = $(".expr-field");
  var exprField = MQ.MathField(exprSpans[exprSpans.length-1], {
    spaceBehavesLikeTab: true,
    restrictMismatchedBrackets: true,
    supSubsRequireOperand: true,
    autoSubscriptNumerals: true,
    autoCommands: "sqrt nthroot",
    autoOperatorNames: "ln log",
    handlers: {
      edit: (exprField) => {
        var answerField = answerFields[curFieldId];
        if(answerField == null) { return; }
        try {
          answerField.latex(
            Opal.eval("Calculator::Parser.new(%q{"+exprField.latex()+"}).run")
          );
        } catch {
          answerField.latex("");
        }
      },
      enter: (exprField) => {
        if(exprField.latex() != "") { createMathField(); }
      },
      upOutOf: (exprField) => {
        selectMathField(curFieldId-1);
      },
      downOutOf: (exprField) => {
        selectMathField(curFieldId+1);
      },
      deleteOutOf: (dir, exprField) => {
        if(curFieldId > 0 && dir < 0 && exprField.latex() == "") {
          $(".equation-field")[curFieldId].remove();
          answerFields.splice(curFieldId);
          exprFields.splice(curFieldId);
          selectMathField(curFieldId-1);
        }
      }
    }
  });
  exprFields.push(exprField);
  selectMathField(curFieldId);
}

function selectMathField(id) {
  var field = $(".expr-field")[id];
  if(field != undefined) {
    field.children[1].click();
    $(field).mousedown().mouseup();
  }
}

function switchField(event) {
  for(var i = 0; i < $(".equation-field").length; i++) {
    $(".equation-field")[i].classList.remove("active");
  }
  var field = event.target.parentElement.parentElement;
  curFieldId = fieldsArray().indexOf(field)
  field.classList.add("active");
}

function fieldsArray() {
  return Array.from($(".equation-field"));
}

function addButtons() {
  for(var i = 0; i < buttonsContainer.children.length; i++) {
    var button = buttonsContainer.children[i].children[0];
    MQ.StaticMath(button).latex(button.dataset.latex);
    button.parentElement.addEventListener("click", (e) => {
      exprFields[curFieldId].typedText(e.target.dataset.op);
      selectMathField(curFieldId);
    });
  }
}
