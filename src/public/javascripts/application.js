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
                var msg = '', selNodes = tree.getChecked();
                Ext.each(selNodes, function(node){
                    if(msg.length > 0){
                        msg += ',';
                    }
                    msg += node.id.substr(1);
                });
                Ext.get(node_result_id).set({value:msg});
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

   if (Ext.get('catalog_tree_single_select')) {
    root = new Ext.tree.AsyncTreeNode({
        text: 'Invisible Root',
        id:'0'
      });
    
    tree=new Ext.tree.TreePanel({
        renderTo: 'catalog_tree_single_select',
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

        if(checked) {
                    Ext.each(checkedNode.ownerTree.getChecked(), function(node) {
                        if(node.id !== checkedNode.id) {
                            node.ui.toggleCheck(false);
                        }
                    });
                }
            }
         }

    });
   root.expand();
   if(selected_node_path!="-1") {
      
      var sp = selected_node_path.lastIndexOf('/');
      
      tree.expandPath(selected_node_path.substr(0, sp), 'id', function(bSuccess, oLastNode) {
                                
				if (bSuccess && tree.getNodeById(selected_node_path.substr(sp+1))) {
					tree.getNodeById(selected_node_path.substr(sp+1)).ui.toggleCheck(true);
				}
      });
   }
   Ext.get(form_id).on('submit',submitTreeForm);

   }


   if (Ext.get('catalog_tree_multi_select')) {
    root = new Ext.tree.AsyncTreeNode({
        text: 'Invisible Root',
        id:'0'
      });


    tree=new Ext.tree.TreePanel({
        renderTo: 'catalog_tree_multi_select',
         root: root,
          rootVisible:false,
           border: false,
          loader: new Ext.tree.TreeLoader({
          url: "/catalogs/"+catalog_id+"?checkbox=true",
          requestMethod:'GET',
          baseParams:{format:'json'}
        })
    });
   root.expand();
   Ext.get(form_id).on('submit',submitTreeForm)
   }
   

});