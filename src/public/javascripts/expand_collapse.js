/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function Expand(node)
{
          // Change the image
          if (node.children.length > 0)
          {
               if (node.children.item(0).tagName == "IMG")
               {
                    node.children.item(0).src = "minus.gif";
               }
          }

          node.nextSibling.style.display = '';
}

function Collapse(node)
{
          // Change the image
          if (node.children.length > 0)
          {
               if (node.children.item(0).tagName == "IMG")
               {
                    node.children.item(0).src = "plus.gif";
               }
          }

          node.nextSibling.style.display = 'none';
}

function Toggle(node)
{
     // Unfold the branch if it isn't visible
     if (node.nextSibling.style.display == 'none')
     {
          Expand(node);
     }
     // Collapse the branch if it IS visible
     else
     {
         Collapse(node);
     }

}

function ExpandAll(num)
{
    var node;
    var count;
    for(var i = 1; i < num; i++)
    {
            count = "sub" + i;
            node = document.getElementById(count);
            if (node)
                  if (node.nextSibling.style.display == 'none') Expand(node);
            count = "";
    }
}

function CollapseAll(num)
{
    var node;
    var count;
    for(var i = 1; i < num; i++)
    {
            count = "sub" + i;
            node = document.getElementById(count);
            if (node)
                  if (node.nextSibling.style.display != 'none') Collapse(node);
            count = "";
    }
}