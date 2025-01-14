def food():
    while True:
        food = input("You find some berries. Do you eat them? (y/n):  ")
        if food == "Y" or food == "y":
            import random
            number = random.randint(1, 2)
            if number == 1:
                print("The berries were poisonous. You died :(")
                return 1
            elif number == 2:
                print("Yay! The berries weren't poisonous!")
                return 0
        elif food == "N" or food == "n":
            import random
            number = random.randint(1, 2)
            if number == 1:
                print("You couldn't find any other food and died. :(")
                return 1
            elif number == 2:
                print(
                    "Yay! You found some berries you recognised and were safe!"
                )
                return 0
        else:
            print("Please answer with a 'y' for yes or 'n' for no.")


def shelter():
    shelter = input("You find a cave. Do you go inside? (y/n):  ")
    if shelter.upper() == "Y":
        import random
        number = random.randint(1, 2)
        if number == 1:
            print("There was a lion in the cave. You died :(")
            return 1
        elif number == 2:
            print("Yay! The cave was empty!")
            return 0
    elif shelter.upper() == "N":
        import random
        number = random.randint(1, 2)
        if number == 1:
            print("You couldn't find any other shelter and died. :(")
            return 1
        elif number == 2:
            print("Yay! You found another safer looking cave and survived!")
            return 0
    else:
        print("Please answer with a 'y' for yes or 'n' for no.")


name = input("What is your name? ")
name = name.capitalize()
print("Hello, " + name + "!")
print()
input(
    "In this game, you will make choices that decide your fate and survival! Each choice you make will have a randomised outcome. Good luck :)"
)
print()

while True:
    choice = input(
        "You wake up in a random forest with no idea where you are. Do you look for food(1) or shelter(2)? "
    )
    print()
    if choice == "1":
        death = food()
        if death == 1:
            again = input("Do you want to play again? (y/n): ")
            if again.upper() == "Y":
                pass
            else:
                print("Okay bye!")
                break
        elif death == 0:
            print()
            print("You then go to look for shelter.")
            death = shelter()
            if death == 1:
                again = input("Do you want to play again? (y/n): ")
                if again.upper() == "Y":
                    pass
                else:
                    print("Okay bye!")
                    break
            else:
                print("Well done! You survived the forest... for now.")
                again = input("Do you want to play again? (y/n): ")
                if again.upper() == "Y":
                    pass
                else:
                    print("Okay bye!")
                    break

    elif choice == "2":
        print()
        death = shelter()
        if death == 1:
            again = input("Do you want to play again? (y/n): ")
            if again.upper() == "Y":
                pass
            else:
                print("Okay bye!")
                break
        elif death == 0:
            print()
            print("You then go to look for food.")
            death = food()
            if death == 1:
                again = input("Do you want to play again? (y/n): ")
                if again.upper() == "Y":
                    pass
                else:
                    print("Okay bye!")
                    break
            else:
                print("Well done! You survived the forest... for now.")
                again = input("Do you want to play again? (y/n): ")
                if again.upper() == "Y":
                    pass
                else:
                    print("Okay bye!")
                    break
