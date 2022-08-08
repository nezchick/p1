   function my_location() {        
        // Geolocation API에 액세스할 수 있는지를 확인
        if (navigator.geolocation) {
            //위치 정보를 얻기
            navigator.geolocation.getCurrentPosition (function(pos) {
                var lat = document.getElementById("lat");
                lat.value = pos.coords.latitude; // 위도
                var lnt = document.getElementById("lnt");
                lnt.value = pos.coords.longitude; // 경도
            });
        } else {
            alert("이 브라우저에서는 위치 정보를 불러올 수 없습니다.")
        }
    };
    
    function distance() {
	var lat = document.getElementById("lat");
	var lnt = document.getElementById("lnt");
}; 