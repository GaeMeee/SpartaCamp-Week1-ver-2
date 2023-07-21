import Foundation

enum RoomType: Int, CaseIterable {
    case one = 1, two, three, four, five
    
    var price: Int {                                   // 연산 프로퍼티를 이용해 각 방 가격 책정
        return self.rawValue * 10000
    }
}

struct Reservation {
    let roomNumber: Int
    let checkInDate: String
    let checkOutDate: String
    let roomPrice: Int
}

class Hotel {
    var myAccount: Int = 0
    var myAccountList: [String] = []                    // 계좌 입출금 내역
    var reservationList: [Reservation] = []             // 나의 예약 목록
    let numberFormatter = NumberFormatter()             // 천원 단위 콤마
    
    
    func randomMoneyDeposit() {                         // 1번 입력 시 랜덤금액 지급
        let randomMoney = Int.random(in: 10...50) * 10000
        print("\(randomMoney)원이 입금되었습니다")
        myAccount += randomMoney
        myAccountList.append("랜덤으로 \(randomMoney)원이 입금되었습니다")
    }
    
    func checkRooms() {                                 // 2번 입력 시 방 목록 체크
        for roomType in RoomType.allCases {
            print("\(roomType.rawValue)번방 1박 \(roomType.price)")
        }
    }
    
    func reservationRoom() {                            // 3번 입력 시 객실 예약
        print("방 번호, 체크인 날짜, 체크아웃 날짜를 각각 입력해주세요")
        print("\n---------------------------------------------------------")
        print("방 번호를 입력하세요: ", terminator: "")
        if let roomInput = readLine(), let roomNumber = Int(roomInput), let selectedRoomType = RoomType(rawValue: roomNumber) {
            print("체크인 날짜를 입력하세요(ex. 2023-03-12): ", terminator: "")
            if let checkInDate = readLine() {
                print("체크아웃 날짜를 입력하세요(ex. 2023-03-15): ", terminator: "")
                if let checkOutDate = readLine() {
                    let choiceRoomPrice = selectedRoomType.price
                    if choiceRoomPrice <= myAccount {
                        let reservation = Reservation(roomNumber: selectedRoomType.rawValue, checkInDate: checkInDate, checkOutDate: checkOutDate, roomPrice: choiceRoomPrice)
                        reservationList.append(reservation)
                        myAccountList.append("예약으로 \(choiceRoomPrice)원이 출금되었습니다")
                    } else {
                        print("잔액 부족으로 예약하실 수 없습니다")
                    }
                } else {
                    print("올바른 번호를 입력해주세요")
                }
            } else {
                print("올바른 번호를 입력해주세요")
            }
        } else {
            print("올바른 번호를 입력해주세요")
        }
    }
    
    func showMyReservation() {                          // 4번 입력 시 나의 예약 목록
        if reservationList.isEmpty {
            print("예약된 방이 없습니다")
        } else {
            for (index, reservation) in reservationList.enumerated() {
                print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)")
            }
        }
    }
    
    func showMyRservationByCheckinDate() {              // 5번 입력 시 예약 목록 체크인 순서
        let sortedReservation = reservationList.sorted(by: { $0.checkInDate < $1.checkInDate })
        if reservationList.isEmpty {
            print("예약된 방이 없습니다")
        } else {
            for (index, reservation) in reservationList.enumerated() {
                print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)")
            }
        }
    }
    
    func cancelRservation() {                           // 6번 입력 시 예약 삭제
        if reservationList.isEmpty {
            print("예약된 방이 없습니다")
        } else {
            for (index, reservation) in reservationList.enumerated() {
                print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)")
            }
            print("\n취소할 예약 번호를 입력해주세요: ", terminator: "")
            if let cancelInput = readLine(), let cancelRoom = Int(cancelInput), cancelRoom > 0 {
                let cancelIndex = cancelRoom - 1
                if cancelIndex < reservationList.count {
                    let cancelRservation = reservationList.remove(at: cancelIndex)
                    myAccount += cancelRservation.roomPrice
                    print("예약이 취소되어 \(cancelRservation.roomPrice)원이 환불되었습니다")
                    myAccountList.append("예약 취소로 \(cancelRservation.roomPrice)원이 입금되었습니다")
                } else {
                    print("올바른 번호를 입력해주세요")
                }
            } else {
                print("올바른 번호를 입력해주세요")
            }
        }
    }
    
    func editReservation() {                            // 7번 입력 시 예약 수정
        if reservationList.isEmpty {
            print("예약된 방이 없습니다")
        } else {
            for (index, reservation) in reservationList.enumerated() {
                print("\(index + 1). \(reservation.roomNumber)번방 체크인: \(reservation.checkInDate), 체크아웃: \(reservation.checkOutDate), 1박 가격: \(reservation.roomPrice)")
            }
            print("\n변경할 예약 번호를 입력해주세요: ", terminator: "")
            if let editInput = readLine(), let editRoom = Int(editInput), editRoom > 0 {
                let editIndex = editRoom - 1
                if editIndex < reservationList.count {
                    let editReservation = reservationList[editIndex]
                    print("현재 예약 정보: \(editReservation.roomNumber)번방 체크인: \(editReservation.checkInDate), 체크아웃: \(editReservation.checkOutDate), 1박 가격: \(editReservation.roomPrice)")
                    print("\n원하시는 방을 수정해주세요: ", terminator: "")
                    if let newInput = readLine(), let newRoomNumer = Int(newInput), let newSelectedRoom = RoomType(rawValue: newRoomNumer) {
                        print("체크인 날짜를 수정해주세요(ex. 2023-03-12): ", terminator: "")
                        if let newCheckInDate = readLine() {
                            print("체크아웃 날짜를 수정해주세요(ex. 2023-03-15): ", terminator: "")
                            if let newCheckOutDate = readLine() {
                                let differencePrice = editReservation.roomPrice - newSelectedRoom.price
                                if differencePrice <= myAccount {
                                    let newReservation = Reservation(roomNumber: newSelectedRoom.rawValue, checkInDate: newCheckInDate, checkOutDate: newCheckOutDate, roomPrice: newSelectedRoom.price)
                                    reservationList[editIndex] = newReservation
                                    
                                    if differencePrice < 0 {
                                        myAccount += differencePrice
                                        myAccountList.append("예약 변경으로 차액 \(-(differencePrice))원이 출금되었습니다")
                                    } else if differencePrice > 0 {
                                        myAccount += differencePrice
                                        myAccountList.append("예약 변경으로 차액 \(differencePrice)원이 입금되었습니다")
                                    } else {
                                        print("예약 변경으로 차액이 발생하지 않았습니다")
                                    }
                                } else {
                                    print("잔액 부족으로 예약 변경하실 수 없습니다")
                                }
                            } else{
                                print("올바른 번호를 입력해주세요")
                            }
                        } else {
                            print("올바른 번호를 입력해주세요")
                        }
                    } else {
                        print("올바른 번호를 입력해주세요")
                    }
                }
            } else {
                print("올바른 번호를 입력해주세요")
            }
        }
    }
    
    func showMyAccountHistory() {                       // 8번 입력 시 입출금 내역서
        if myAccountList.isEmpty {
            print("입출금 내역이 없습니다")
        } else {
            for (index, record) in myAccountList.enumerated() {
                print("\(index + 1). \(record)")
            }
        }
    }
    
    func showMyAccountBalance() {                       // 9번 입력 시 잔액확인 및 천원 단위 콤마
        let myAccountFormatter = numberFormatter.string(for: myAccount) ?? "0"
        print("잔액은 \(myAccountFormatter)원입니다")
    }
    
    func startProgram() {
        while true {// 프로그램을 종료하지 않는 이상 무한 반복
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
                    randomMoneyDeposit()
                case 2:
                    checkRooms()
                case 3:
                    reservationRoom()
                case 4:
                    showMyReservation()
                case 5:
                    showMyRservationByCheckinDate()
                case 6:
                    cancelRservation()
                case 7:
                    editReservation()
                case 8:
                    showMyAccountHistory()
                case 9:
                    showMyAccountBalance()
                case 0:
                    print("프로그램을 종료합니다")
                    return
                default:
                    break
                }
            }
        }
    }
}

let start = Hotel()

start.startProgram()
