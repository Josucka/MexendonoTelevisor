from encapsulamento import Televisor

tv = Televisor('canal', 'volume')

while True:
    opcao = int(input('''
        Comando
        [ 1 ] Trocar Canal
        [ 2 ] Controlar Volume
        [ 3 ] Destligar tv

            '''))

    if opcao == 1:
        canal = int(input('Informe o canal: '))
        print(f'O canal {canal} esta sem sinal')
        
    elif opcao == 2:
        volume = str(input('Digite + pra almentar - pra diminuir '))
        print(f'Volume em {volume}')
        if volume == '+':
            volume += 1
        elif volume == 0:
            print('MUDO')
    elif opcao == 3:
        print('Good By')
        break       
    else:
        break
