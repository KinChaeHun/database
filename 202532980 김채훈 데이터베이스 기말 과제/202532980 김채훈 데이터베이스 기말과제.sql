-- 테이블 삭제
drop table sale_detail cascade constraints;
drop table disposal cascade constraints;
drop table payment cascade constraints;
drop table sale cascade constraints;
drop table product cascade constraints;
drop table employee cascade constraints;

-- 테이블 생성
create table product (
    product_code     varchar2(20) primary key,
    product_name     varchar2(100) not null,
    price            number check (price >= 0),
    category         varchar2(50),
    expiration_date  date,
    event_flag       char(1) check (event_flag in ('y','n')),
    stock_quantity   number check (stock_quantity >= 0)
);

create table employee (
    employee_name varchar2(50) primary key,
    phone         varchar2(20) not null,
    address       varchar2(200)
);

create table sale (
    sale_id        number primary key,
    sale_date      date not null,
    employee_name  varchar2(50),
    payment_id     number,
    foreign key (employee_name) references employee(employee_name)
);

create table payment (
    payment_id     number primary key,
    sale_id        number,
    payment_type   varchar2(20),
    foreign key (sale_id) references sale(sale_id)
);

create table sale_detail (
    sale_id       number,
    product_code  varchar2(20),
    sale_quantity number check (sale_quantity >= 1),
    primary key (sale_id, product_code),
    foreign key (sale_id) references sale(sale_id),
    foreign key (product_code) references product(product_code)
);

create table disposal (
    product_code      varchar2(20),
    disposal_date     date,
    disposal_quantity number check (disposal_quantity >= 1),
    primary key (product_code, disposal_date),
    foreign key (product_code) references product(product_code)
);

-- 기본 데이터 생성

insert into employee values ('홍길동', '010-1111-2222', '부산광역시 기장군');
insert into employee values ('김철수', '010-3333-4444', '부산광역시 기장군');
insert into employee values ('김민수', '010-5555-6666', '부산광역시 기장군');
insert into employee values ('김민지', '010-7777-8888', '부산광역시 기장군');

insert into product values ('1', '콜라', 2000, '음료', date '2026-12-31', 'y', 24);
insert into product values ('2', '사이다', 1500, '음료', date '2026-12-31', 'y', 24);
insert into product values ('3', '컵라면', 1200, '식품', date '2026-05-30', 'n', 20);
insert into product values ('4', '초코바', 800, '식품', date '2025-11-10', 'n', 20);
insert into product values ('5', '샌드위치', 3500, '식품', date '2025-12-15', 'y', 5);
insert into product values ('6', '생수', 700, '음료', date '2027-12-31', 'y', 30);

insert into sale values (1, date '2025-12-12', '김철수', null);
insert into sale values (2, date '2025-12-11', '김민수', null);
insert into sale values (3, date '2025-12-07', '김민지', null);

insert into payment values (1001, 1, '카드');
insert into payment values (1002, 2, '현금');
insert into payment values (1003, 3, '카카오페이');

insert into sale_detail values (1, '1', 2);
insert into sale_detail values (1, '4', 1);
insert into sale_detail values (2, '2', 1);
insert into sale_detail values (2, '3', 2);
insert into sale_detail values (3, '5', 1);

insert into disposal values ('4', date '2025-11-10', 5);
insert into disposal values ('5', date '2025-12-10', 2);\

-- 문제
-- 1. 모든 상품의 전체 정보를 조회하시오.
select * from product;

-- 2. 행사 상품만 조회하시오.
select product_name, price from product where event_flag = 'y';

-- 3. 재고가 20 이하인 상품을 조회하시오.
select product_name, stock_quantity from product where stock_quantity <= 20;

-- 4. 가격이 높은 순으로 상품을 정렬하시오.
select product_name, price from product order by price desc;

-- 5. '식품' 카테고리의 상품만 조회하시오.
select * from product where category = '식품';

-- 6. 유통기한이 2025년인 상품을 조회하시오.
select * from product where extract(year from expiration_date) = 2025;

-- 7. 특정 직원(김철수)의 판매 내역을 조회하시오.
select * from sale where employee_name = '김철수';

-- 8. 판매 테이블을 날짜 기준 내림차순 정렬하시오.
select * from sale order by sale_date desc;

-- 9. 각 상품의 이름과 판매수량을 조회하시오.
select p.product_name, sd.sale_quantity
from sale_detail sd
join product p on sd.product_code = p.product_code;

-- 10. 품절(재고=0) 상품을 조회하시오.
select * from product where stock_quantity = 0;

-- 11. 특정 상품(‘콜라’)의 가격을 2200으로 수정하시오.
update product set price = 2200 where product_name = '콜라';

-- 12. '샌드위치' 재고를 5 증가시키시오.
update product set stock_quantity = stock_quantity + 5 where product_name = '샌드위치';

-- 13. 직원 '홍길동'의 주소를 변경하시오.
update employee set address = '부산광역시 해운대구' where employee_name = '홍길동';

-- 14. 판매 상세에서 sale_id = 1인 모든 데이터를 조회하시오.
select * from sale_detail where sale_id = 1;

-- 15. 2025년에 폐기된 상품 내역을 조회하시오.
select * from disposal where extract(year from disposal_date) = 2025;

-- 16. 결제 방식이 '현금'인 결제 정보를 조회하시오.
select * from payment where payment_type = '현금';

-- 17. 직원 목록을 이름 기준 오름차순 정렬하시오.
select * from employee order by employee_name;

-- 18. 상품 중 가격이 1000원 이상 2000원 이하인 상품을 조회하시오.
select * from product where price between 1000 and 2000;

-- 19. 음료 카테고리의 평균 가격을 구하시오.
select avg(price) as avg_price from product where category = '음료';

-- 20. 판매된 상품별 총 판매수량을 조회하시오.
select product_code, sum(sale_quantity) as total_sold
from sale_detail
group by product_code;

-- 21. 특정 상품(코드='1')의 판매 내역을 조회하시오.
select * from sale_detail where product_code = '1';

-- 22. 현재 재고가 가장 많은 상품을 조회하시오.
select * from product
where stock_quantity = (select max(stock_quantity) from product);

-- 23. 판매가 이루어지지 않은 상품을 조회하시오.
select * from product
where product_code not in (select product_code from sale_detail);

-- 24. 폐기수량이 1 이상인 폐기 기록만 조회하시오.
select * from disposal where disposal_quantity >= 1;

-- 25. 결제ID가 1001인 결제 정보를 삭제하시오.
delete from payment where payment_id = 1001;

-- 26. 소문자로 된 상품명을 모두 대문자로 바꿔 조회하시오.
select upper(product_name) from product;

-- 27. 판매ID가 2인 판매 + 상세 정보를 조인해서 조회하시오.
select s.sale_id, s.sale_date, p.product_name, sd.sale_quantity
from sale s
join sale_detail sd on s.sale_id = sd.sale_id
join product p on sd.product_code = p.product_code
where s.sale_id = 2;

-- 28. 재고가 가장 적은 상위 3개의 상품을 조회하시오.
select * from product order by stock_quantity asc fetch first 3 rows only;

-- 29. 카테고리별 상품 개수를 조회하시오.
select category, count(*) as product_count
from product
group by category;

-- 30. 특정 판매일(2025-12-12)의 판매 정보 조회하시오.
select * from sale where sale_date = date '2025-12-12';


