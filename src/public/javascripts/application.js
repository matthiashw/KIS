// User $j not $ to have no Conflicts with prototype etc

var $j = jQuery.noConflict();
$j.jstree._themes = "/jstreethemes/";

// Catalog show tree Fuction

$j(function () { 
    $j("#show_catalog_jtree")
		.jstree({
                        "core" : {

                        },
                        "themes" : {
                                "theme" : "default",
                                "dots" : false,
                                "icons" : false
                            },


                        "xml_data" : {
                            
                            "ajax" : {
                                "url": this.herf,
                                "dataType" : "xml",
                                "data" : function (n) {
                                    return {
                                    nodeid : n.attr ? n.attr("id") : -1
                                    }
                                }

                            }


                        },

                        "plugins" : [ "themes", "xml_data"]

                });
});

