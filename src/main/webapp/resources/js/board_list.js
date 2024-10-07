const contextPath = 'http://localhost';

document.addEventListener("DOMContentLoaded", function() {
    fetchSearchRank(); // 검색 순위 가져오기
    setupPostLoading(); // 게시물 불러오기 설정

});

function fetchSearchRank() {
    fetch('/shop/rank')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json(); // JSON 데이터로 변환
        })
        .then(data => {
            const searchRankList = document.getElementById('searchRankList');
            searchRankList.innerHTML = ''; // 기존 목록을 지움

            // 데이터가 배열 형태일 경우 각 항목을 리스트에 추가
            data.forEach((rankItem, index) => {
                const listItem = document.createElement('li');
                listItem.textContent = (index + 1) + '. '+rankItem.title;
                searchRankList.appendChild(listItem);

                // 순차적으로 각 항목이 보이도록 지연 설정
                setTimeout(() => {
                    listItem.classList.add('active'); // active 클래스 추가
                }, index * 1000); // 각 항목이 1초 간격으로 나타남
            });

            // 슬라이드 효과로 검색 순위를 보여줌
            slideSearchRank();
        })
        .catch(error => {
            console.error('Error fetching search rank:', error);
        });
}

function slideSearchRank() {
    const items = document.querySelectorAll('#searchRankList li');
    let currentIndex = 0;

    function showNextItem() {
        // 현재 활성화된 항목 숨기기
        items[currentIndex].classList.remove('active');

        // 인덱스를 증가시키고, 마지막 항목에 도달했으면 처음으로 돌아가기
        currentIndex = (currentIndex + 1) % items.length;

        // 다음 항목 보이기
        items[currentIndex].classList.add('active');

        // 리스트 위치 조정
        const listHeight = items[currentIndex].offsetHeight;
        document.getElementById('searchRankList').style.top = `-${currentIndex * listHeight}px`;
    }

    // 처음 항목을 보이게 설정
    items[currentIndex].classList.add('active');

    // 3초마다 다음 항목으로 넘어감
    setInterval(showNextItem, 3000);
}

function setupPostLoading() {
    let pageNum = 2; // 첫 번째 페이지 이후의 게시물을 불러오기 위해 2로 설정
    const amount = 12; // 한 번에 불러올 게시물 수

    // 게시물 불러오기 버튼 클릭 이벤트 설정
    document.getElementById('load-more').addEventListener('click', loadMorePosts);

    function loadMorePosts() {
        console.log(`Loading more posts for page: ${pageNum}, amount: ${amount}`);
        console.log('Context Path:', contextPath);

        fetch(`/shop/listMore?pageNum=${pageNum}&amount=${amount}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json(); // JSON 데이터로 변환
            })
            .then(data => {
                console.log('Data received:', data);

                // 서버에서 받아온 데이터를 처리
                const posts = data.list || [];
                const postContainer = document.getElementById('posts-container');

                if (posts.length === 0) {
                    console.log('No more posts to load.');
                    document.getElementById('load-more').style.display = 'none'; // 버튼 숨김
                    return;
                }

                // 받아온 게시물을 HTML에 추가
                posts.forEach(post => {
                    const imageUrl = `${contextPath}/resources/upload/${post.photo_name}`;
                    console.log('Image URL:', imageUrl);
                    const regidate = new Date(post.regidate);
                    const formattedRegidate = regidate.toISOString().slice(0, 10);
                    const postElement = document.createElement('div');
                    postElement.classList.add('col-xl-2', 'col-lg-3', 'col-md-4', 'col-sm-6', 'post-item');
                    postElement.innerHTML = `
                        <div class="box">
                            <a href="/shop/get?board_number=${post.board_number}">
                                <div class="img-box">
                                    <img src='${contextPath}/resources/upload/${post.photo_name}' alt="게시물 이미지">
                                </div>
                                <div class="detail-box" align="center">
                                    <h6>${post.title}</h6>
                                </div>
                                <div class="card_price">
                                    <span>${post.price} 원</span>
                                </div>
                                <div class="card_address">
                                    ${post.board_address}
                                </div>
                                <div class="card_status">
                                    ${post.status}
                                </div>
                                <div class="card_count">
                                    <span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-suit-heart" viewBox="0 0 16 16" style="margin-right: 10px;">
                                        <path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.6 7.6 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.381z"/>
                                    </svg>${post.interest}</span>
                                    <span><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-eye-fill" viewBox="0 0 16 16" style="margin-right: 10px;">
                                        <path d="M10.5 8a2.5 2.5 0 1 1-5 0 2.5 2.5 0 0 1 5 0"/>
                                        <path d="M0 8s3-5.5 8-5.5S16 8 16 8s-3 5.5-8 5.5S0 8 0 8m8 3.5a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7"/>
                                    </svg>${post.views}</span>
                                </div>
                                <div class="regidate">
                                    ${formattedRegidate}
                                </div>
                            </a>
                        </div>
                    `;
                    postContainer.appendChild(postElement);
                });

                // 페이지 번호 증가
                pageNum++;

                // 로그로 페이지와 게시물 추가 확인
                console.log(`Next page: ${pageNum}, posts added: ${posts.length}`);
            })
            .catch(error => {
                console.error('Error loading posts:', error);
            });
    }
}