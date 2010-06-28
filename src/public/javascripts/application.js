/*
 * Loading Bar feature ( use = render :partial => 'shared/loading_bar_element'
 * and onSubmit  callback to present loading bar) :onSubmit => "showAjaxLoadingBar()"
 */

function showAjaxLoadingBar() {
    document.getElementById('loading_ajax_image').style.display= "block"; 
}


/*
 * Catalog Library
 */

var tree;


function submitTreeForm(){
    var msg="";
    Ext.each(nodeselection, function(node){
        if(msg.length > 0){
            msg += ',';
        }
        msg += node.substr(1);
    });
    Ext.get(node_result_id).set({value:msg});
}

function checkSelection(tree,parent,node) {
   if(node.leaf==true) {
    if (nodeselection.indexOf(node.id.toString())!=-1) {
                node.attributes['checked']=true;
    }
   }
}


function uncheckNodeFromTree(id) {
    nodeselection.remove(id);
}

function checkNodeFromTree(id) {
    nodeselection.push(id);
     
}

Ext.onReady(function(){
   if (Ext.get('catalog_tree')) {
    root = new Ext.tree.AsyncTreeNode({
        text: 'Invisible Root',
        id:'0'
      });
    

    tree=new Ext.tree.TreePanel({
        renderTo: 'catalog_tree',
         root: root,
          rootVisible:false,
           border: false,
          loader: new Ext.tree.TreeLoader({
          url: "/catalogs/"+catalog_id,
          requestMethod:'GET',
          baseParams:{format:'json'}
        }) 

    });
   root.expand();

   }
   
   if (Ext.get('catalog_tree_select')) {
    root = new Ext.tree.AsyncTreeNode({
        text: 'Invisible Root',
        id:'0'
      });


    tree=new Ext.tree.TreePanel({
        renderTo: 'catalog_tree_select',
         root: root,
          rootVisible:false,
           border: false,
          loader: new Ext.tree.TreeLoader({
          url: "/catalogs/"+catalog_id+"?checkbox=true",
          requestMethod:'GET',
          baseParams:{format:'json'}
        }),
         listeners: {
            'checkchange': function(checkedNode, checked){
                 if(!checked) {
                      uncheckNodeFromTree(checkedNode.id);
                  } else {
                      checkNodeFromTree(checkedNode.id);
                      if(single_selection) {
                             Ext.each(tree.getChecked(), function(node) {
                             if(node.id != checkedNode.id) {
                                uncheckNodeFromTree(node.id)
                                node.ui.toggleCheck(false);
                             }
                        });
                        }
                 }
           }
         }
    });
   tree.on('append',checkSelection);
   root.expand();
    // Open a node path
    if( selected_node_path!="-1") {
      tree.expandPath(selected_node_path, 'id');
   }
   Ext.get(form_id).on('submit',submitTreeForm)
   }
  });