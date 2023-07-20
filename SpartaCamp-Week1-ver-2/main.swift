import Foundation

enum HotelRoom: Int, CaseIterable {
    case one = 1, two, three, four, five
    
    var price: Int {                                   // 연산 프로퍼티를 이용해 각 방 가격 책정
        return self.rawValue * 10000
    }
}

struct HotelInformation {
    let roomNumber: Int
    let checkInDate: String
    let checkOutDate: String
    let roomPrice: Int
}

func main() {
    var myAccount: Int = 0
    let numberFormatter = NumberFormatter()             // 천원 단위 콤마
    numberFormatter.numberStyle = .decimal
    var myAccountList: [String] = []                    // 계좌 입출금 내역
    var reservationList: [HotelInformation] = []        // 나의 예약 목록
    
    while true {        // 프로그램을 종료하지 않는 이상 무한 반복
        print("""
              ---------------------------------------------------------
              1. 랜덤 금액 지급
              2. 호텔 객실 정보 보기
              3. 호텔 객실 예약하기
              4. 나의 예약 목록 보기
              5. 나의 예약 목록 체크인 날짜 순으로 보기
              6. 예약 삭제하기
              7. 예약 수정하기
              8. 나의 입출금 내역 출력하기
              9. 나의 잔액 보기
              0. 프로그램 종료하기
              ---------------------------------------------------------
              
              원하시는 기능의 번호를 입력해주세요
              """)
        if let input = readLine(), let choiceNum = Int(input) {
            switch choiceNum {
            case 1:
                let randomMoney = Int.random(in: 10...50) * 10000               // 10만 ~ 50만원, 10000원 단위
                print("\(randomMoney)원 입금되었습니다")
                myAccount += randomMoney                                        // 랜덤 지급 금액을 계좌에 입금
                myAccountList.append("랜덤으로 \(randomMoney)원이 입금되었습니다.")     // 입출금 내역에 추가
            case 2:
                for room in HotelRoom.allCases {                                // HotelRoom 열거형에 CasIterable 프로토콜 추가하여 각 케이스 방 번호
                    print("\(room.rawValue)번방 1박 \(room.price)원")
                }
            case 3:
                print("방 번호, 체크인 날짜, 체크아웃 날짜를 각각 입력해주세요")
                print("---------------------------------------------------------")
                print("방 번호를 입력하세요: ", terminator: "")
                if let roomInput = readLine(), let roomNumber = Int(roomInput), let selectedRoom = HotelRoom(rawValue: roomNumber) {
                    print("체크인 날짜를 입력하세요(ex. 2023-03-12): ", terminator: "")
                    if let checkInDate = readLine() {
                        print("체크아웃 날짜를 입력하세요(ex. 2023-03-15): ", terminator: "")
                        if let checkOutDate = readLine() {
                            let choiceRoomPrice = selectedRoom.price
                            if choiceRoomPrice <= myAccount {
                                let reservation = HotelInformation(roomNumber: selectedRoom.rawValue, checkInDate: checkInDate, checkOutDate: checkOutDate, roomPrice: choiceRoomPrice)         // 입력받은 값들을 HotelInformaiton 구조체를 사용하여 예약 정보를 생성
                                
                                reservationList.append(reservation)             // 예약 목록 리스트에 정보 입력
                                
                                myAccountList.append("예약으로 \(choiceRoomPrice)원이 출금되었습니다")       // 입출금 내역에 추가
                                
                                print("예약이 완료되었습니다")
                            }
                            else {
                                print("잔액이 부족하여 예약하실 수 없습니다")
                            }
                        }
                    }
                }
            case 4:
                if reservationList.isEmpty {
                    print("예약된 방이 없습니다")
                } else {
                    for (index, reservation) in reservationList.enumerated() {
                        print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)원")
                    }
                }
            case 5:
                let sortedReservationList = reservationList.sorted(by: { $0.checkInDate < $1.checkInDate })     // 체크인 날짜 순서대로 정렬하는 상수
                if sortedReservationList.isEmpty {
                    print("예약된 방이 없습니다")
                }
                else {
                    for (index, reservation) in sortedReservationList.enumerated() {
                        print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)원")
                    }
                }
            case 6:
                if reservationList.isEmpty {
                    print("예약된 방이 없습니다")
                } else {
                    for (index, reservation) in reservationList.enumerated() {
                        print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)원")
                    }
                    print("\n 취소할 예약 번호를 입력하세요: ", terminator: "")
                    if let cancelInput = readLine(), let cancelRoom = Int(cancelInput), cancelRoom > 0 {        // 삭제할 번호는 1부터 시작이기에 0보다 커야 한다는 조건
                        let cancelIndex = cancelRoom - 1                                                        // 배열은 0부터 시작하는 특성이 있어 실제 예약 목록의 인덱스는 0, 1, 2... 여서 입력받는 cancelRoom에 -1을 더하여 원하는 목록 삭제
                        let canceledReservation = reservationList.remove(at: cancelIndex)
                        myAccount += canceledReservation.roomPrice
                        print("예약이 취소되어 \(canceledReservation.roomPrice)원이 환불되었습니다")
                        myAccountList.append("예약 취소로 \(canceledReservation.roomPrice)원이 입금되었습니다")
                    } else {
                        print("올바른 번호를 입력해주세요")
                    }
                }
            case 7:
                if reservationList.isEmpty {
                    print("예약된 방이 없습니다")
                } else {
                    for (index, reservation) in reservationList.enumerated() {
                        print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)원")
                    }
                    print("\n변경할 예약 번호를 입력하세요: ", terminator: "")
                    if let editInput = readLine(), let editRoom = Int(editInput), editRoom > 0 {
                        let editIndex = editRoom - 1
                        if editIndex < reservationList.count {
                            let editedReservation = reservationList[editIndex]
                            print("현재 예약 정보: \(editedReservation.roomNumber)번방 체크인: \(editedReservation.checkInDate), 체크아웃: \(editedReservation.checkOutDate), 1박: \(editedReservation.roomPrice)원")
                            print("\n원하시는 방을 수정해주세요: ", terminator: "")
                            if let newInput = readLine(), let newRoomNum = Int(newInput), let newSelectedRoom = HotelRoom(rawValue: newRoomNum) {
                                print("체크인 날짜를 수정해주세요(ex. 2023-03-12): ", terminator: "")
                                if let newCheckInDate = readLine() {
                                    print("체크아웃 날짜를 수정해주세요(ex. 2023-03-15): ", terminator: "")
                                    if let newCheckOutDate = readLine() {
                                        let differencePrice = editedReservation.roomPrice - newSelectedRoom.price               // 전에 예약했던 방 가격과 새로 선택한 방 가격의 차액
                                        
                                        if differencePrice <= myAccount {                           // 계좌의 잔액이 차액보다 많은 조건
                                            let newReservation = HotelInformation(roomNumber: newSelectedRoom.rawValue, checkInDate: newCheckInDate, checkOutDate: newCheckOutDate, roomPrice: newSelectedRoom.price)
                                            
                                            reservationList[editIndex] = newReservation             // 기존 정보가 저장된 배열의 해당 인덱스를 새로운 예약 정보로 교체
                                            
                                            if differencePrice < 0 {
                                                myAccount += differencePrice
                                                myAccountList.append("예약 변경으로 차액 \(differencePrice)원 출금되었습니다")
                                            } else if differencePrice > 0 {
                                                myAccount += differencePrice
                                                myAccountList.append("예약 변경으로 차액 \(differencePrice)원 입금되었습니다")
                                            }
                                            print("예약 정보가 수정되었습니다")
                                        }
                                        else {
                                            print("잔액이 부족하여 에약 변경하실 수 없습니다")
                                        }
                                    }
                                }
                            }
                            else {
                                print("올바른 번호를 입력해주세요")
                            }
                        }
                    }
                    else {
                        print("올바른 번호를 입력해주세요")
                    }
                }
            case 8:
                if myAccountList.isEmpty {
                    print("입출금 내역이 없습니다")
                } else {
                    for record in myAccountList {
                        print("\(record.count). \(record)")
                    }
                }
            case 9:
                let myAccountFormatter = numberFormatter.string(for: myAccount) ?? "0"
                print("잔액은 \(myAccountFormatter)원입니다")
            default:
                if choiceNum == 0 {
                    print("프로그램을 종료합니다.")
                    return
                }
            }
        }
    }
}

main()
