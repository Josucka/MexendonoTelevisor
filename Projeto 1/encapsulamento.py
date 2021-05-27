#Exercicio para treinar ABSTRAÇÃO e ENCAPSULAMENTO:

#Faça um programa que simule um televisor criando-o como um objeto. ​
#O usuário deve ser capaz de informar o número do canal e aumentar ou diminuir o volume.​
#Certifique-se de que o número do canal e o nível do volume permanecem dentro de faixas válidas.

class Televisor:
    def __init__ (self, canal, volume):
        self.canal = canal
        self.volume = volume
    
    def volume(self, tv_volume=1):
        if self.volume != 0:
            if self.volume == '+':
                tv_volume += 1
                print(f'O Volume do canal esta em: {self.volume}')
            else:
                print('Mudo')

    def canal(self, num=250):
        if self.canal != 0:
            if self.canal <= num:
                print(f'Canal escolhido {self.canal}')
            else:
                print('canal invalido')

