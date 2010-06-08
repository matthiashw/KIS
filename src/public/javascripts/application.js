// User $j not $ to have no Conflicts with prototype etc

var $j = jQuery.noConflict();
$j.jstree._themes = "/jstreethemes/";

// Catalog show tree Fuction

$j(function () { 
    $j("#show_catalog_jtree")
		.jstree({
                        "core" : {
                                "html_titles" :true,
                                 "animation" : 0
                        },
                        "themes" : {
                                "theme" : "default",
                                "dots" : false,
                                "icons" : true
                            },
                        "json_data" : {
                            
                            "ajax" : {
                                "dataType" : "json",
                                "data" : function (n) {
                                    return {
                                    nodeid : n.attr ? n.attr("id") : -1
                                    }
                                }
                            

                            },
                            "progressive_render"  : true

                        },
                       
                        "plugins" : [ "themes", "json_data"]


                });
});

