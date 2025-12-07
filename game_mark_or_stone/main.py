"""
projekt_2.py: druhý projekt do Engeto Online Python Akademie

author: Halyna Kaida
email: lina.g@ukr.net
"""

import random
SEPARATOR = "=" * 55
field = [" "] * 9

def print_rules():
    print("GAME RULES:\n" 
        "\nEach player can place one mark (or stone)"
        "\nper turn on the 3x3 grid. The WINNER is"
        "\nwho succeeds in placing three of their"
        "\nmarks in a:" 
        "\n* horizontal," 
        "\n* vertical or" 
        "\n* diagonal row" 
        )
    
def print_field():
    print("+---+---+---+")
    print("|", field[0], "|",  field[1],"|",  field[2], "|")
    print("+---+---+---+")
    print("|", field[3],"|",  field[4],"|",  field[5],"|")
    print("+---+---+---+")
    print("|", field[6],"|",  field[7],"|",  field[8],"|")
    print("+---+---+---+")

def field_fill_in(player: str, players_num: str) -> int:
    if player == player1 or (player == player2 and players_num == "2"):
        print(f"{SEPARATOR}\nYour turn {player} | ", end="")
        while True:
            player_move = input("Please enter your move number (1 - 9): ")
            print(SEPARATOR)
            if player_move not in ["1", "2", "3", "4", "5", "6", "7", "8", "9"]:
                print("You enter incorrect number.")
                continue
            player_move = int(player_move)
            if field[player_move - 1] != " ":
                print(f"{SEPARATOR}\nThis sell is occupied. Try again.")                   
            else:           
                return player_move
    if player == player2:
        print(f"{SEPARATOR}\nMy turn.")       
        while True:
            player_move = random.randint(1, 9)     
            if field[player_move - 1] != " ":
                continue
            else:
                print(f"{SEPARATOR}\nMy number is: {player_move}\n{SEPARATOR}")
                return player_move
    
def set_value(player: str,): 
        """
        Set values:
        - "o" for first player
        - "x" for second player
        """
        move = field_fill_in(player, num_of_players)
        if player == player1:
            field.pop(move - 1)
            field.insert(move - 1, "o")
        if player == player2:
            field.pop(move - 1)
            field.insert(move - 1, "x")

def set_winner(player: str) -> bool:
    """
    Set a winner. Return "True", if one of the condition is True,
    else return "False".
    """
    if (field[0] == field[1] == field[2] != " " or 
        field[3] == field[4] == field[5] != " " or
        field[6] == field[7] == field[8] != " " or
        field[0] == field[3] == field[6] != " " or
        field[1] == field[4] == field[7] != " " or
        field[2] == field[5] == field[8] != " " or
        field[0] == field[4] == field[8] != " " or
        field[2] == field[4] == field[6] != " "
        ):
        print(
              f"{SEPARATOR}\nCongratulation!!! {player.upper()} won.\n"
              f"{SEPARATOR}\nGame over.\n{SEPARATOR}"
              )
        return True
    else: 
        return False
        
def set_players(num_of_players: str) -> list:  
    """
    Set players. If number of players is "1", set 1 player, the second player is a computer.
    If number of players is "2", set 2 players. 
    """
    def set_first_player():
        while True:
            first_player = input("Player 1, please, enter your name: ").title()
            if not first_player or (not first_player.isalnum() or first_player[0].isdigit()):
                print(f"{SEPARATOR}\nYour name should't be empty,"
                      f"content symbols (;:,./ etc.)\n"
                      f"and start with number. Try again.\n{SEPARATOR}")              
            else: 
                return first_player
            
    if num_of_players == "1":
        player1 = set_first_player()
        player2 = "Mario" 
        if player1 == "Mario":
            player2 = "Buddy"
        print(f"{SEPARATOR}\nHello {player1} I'm {player2}. I'll play with you.\n{SEPARATOR}")
    elif num_of_players == "2":
        player1 = set_first_player()
        player2  = input("Player 2, please, enter your name: ").title()
        if player1 == player2:
            player1 += "1"
            player2 += "2" 
    return [player1, player2]

def move(player: str):
    set_value(player)
    print_field()
    if set_winner(player):
        exit()
    if not set_winner(player) and all([f.strip() for f in field]):
        print(
            f"{SEPARATOR}\nIt's a draw.\n"
            f"{SEPARATOR}\nGame over.\n{SEPARATOR}")
        exit()

print(f"\nWelcome to Tic Tac Toe!\n{SEPARATOR}")
print_rules()
num_of_players = input(f"{SEPARATOR}\nHow many players will play this game (1 or 2): ")
print(SEPARATOR)
while True:    
    if num_of_players not in ["1", "2"]:
        num_of_players = input("Please enter the correct number(1 or 2): ")
    else:
        break
player1, player2 = set_players(num_of_players)
print_field()

while True:
    move(player1)
    move(player2)