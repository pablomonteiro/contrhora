$(document).ready(function() {
    $("#export_csv").click(function() {
        var user_id = "";
        if($("#user_id").val())
            user_id = "?user_id="+$("#user_id").val();
        location.href = "/admin/records.csv"+user_id
    })
})
