# -*- encoding: utf-8 -*-
module Brcobranca
  module Boleto
    class Cecred < Base # Cecred
      validates_length_of :agencia, maximum: 4, message: 'deve ser menor ou igual a 4 dígitos.'
      validates_length_of :conta_corrente, maximum: 7, message: 'deve ser menor ou igual a 7 dígitos.'
      validates_length_of :carteira, is: 2, message: 'deve ser igual a 2 dígitos.'
      validates_length_of :convenio, is: 6, message: 'deve ser igual a 6 dígitos.'

      validates_length_of :numero_documento, maximum: 9, message: 'deve ser menor ou igual a 9 dígitos.'

      # Nova instancia do Cecred
      # @param (see Brcobranca::Boleto::Base#initialize)
      def initialize(campos = {})
        campos = { carteira: '1' }.merge!(campos)
        super(campos)
      end

      # Codigo do banco emissor (3 dígitos sempre)
      #
      # @return [String] 3 caracteres numéricos.
      def banco
        '085'
      end

      # Dígito verificador do banco
      # @return [Integer] 1 caracteres numéricos.
      def banco_dv
        "1"
      end

      # Convenio
      # @return [String] 6 caracteres numéricos.
      def convenio=(valor)
        @convenio = valor.to_s.rjust(6, '0') if valor
      end

      # Carteira
      # @return [String] 2 caracteres numéricos.
      def carteira=(valor)
        @carteira = valor.to_s.rjust(2, '0') if valor
      end

      # Número seqüencial utilizado para identificar o boleto.
      # (Número de dígitos depende do tipo de convênio).
      # @raise  [Brcobranca::NaoImplementado] Caso o tipo de convênio não seja suportado pelo Brcobranca.
      #
      # @overload numero_documento
      #   @return [String] 9 caracteres numéricos.
      def numero_documento=(valor)
        @numero_documento = valor.to_s.rjust(9, '0')
      end

      # Nosso número para exibir no boleto.
      # @return [String]
      # @example
      #  boleto.nosso_numero_boleto #=> "10000000027000095-7"
      def nosso_numero_boleto
        "#{conta_corrente}#{conta_corrente_dv}#{numero_documento}"
      end

      # Agência + conta corrente do cliente para exibir no boleto.
      # @return [String]
      # @example
      #  boleto.agencia_conta_boleto #=> "0001-9 / 0000002-7"
      def agencia_conta_boleto
        "#{agencia}-#{agencia_dv} / #{conta_corrente}-#{conta_corrente_dv}"
      end

      # Segunda parte do código de barras.
      # @return [String] 25 caracteres numéricos.
      def codigo_barras_segunda_parte
        "#{convenio}#{nosso_numero_boleto}#{carteira}"
      end
    end
  end
end